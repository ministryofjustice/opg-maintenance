package main

import (
	"context"
	"errors"
	"flag"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/ministryofjustice/opg-go-common/env"
	"github.com/ministryofjustice/opg-maintenance/service-maintenance/internal/server"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/rs/zerolog/pkgerrors"
)

func main() {
	var (
		port = flag.String(
			"port",
			env.Get("MAINTENANCE_PORT", "9005"),
			"Port at which to serve the maintenance application",
		)
	)

	flag.Parse()

	zerolog.ErrorStackMarshaler = pkgerrors.MarshalStack

	srv := &http.Server{
		Handler:      server.NewServer(),
		Addr:         ":" + *port,
		WriteTimeout: 10 * time.Second,
		ReadTimeout:  10 * time.Second,
	}

	go func() {
		log.Info().Str("port", *port).Msgf("server starting on address %s", srv.Addr)

		if err := srv.ListenAndServe(); !errors.Is(err, http.ErrServerClosed) {
			log.Fatal().Stack().Err(err).Msg("server exited")
		}
	}()

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)

	defer func() {
		signal.Stop(c)
	}()

	sig := <-c
	log.Info().Msgf("got %s signal. quitting.", sig)

	tc, cnl := context.WithTimeout(context.Background(), 30*time.Second)
	defer cnl()

	if err := srv.Shutdown(tc); err != nil {
		log.Error().Stack().Err(err).Msg("failed to shutdown server successfully")
	}
}
