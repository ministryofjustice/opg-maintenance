package server

import (
	"errors"
	"fmt"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/ministryofjustice/opg-maintenance/service-maintenance/internal/server/handlers"
	"github.com/rs/zerolog/log"
)

type ErrorHandler func(http.ResponseWriter, int)

type errorInterceptResponseWriter struct {
	http.ResponseWriter
	h ErrorHandler
}

var ErrPanicRecovery = errors.New("error handler recovering from panic()")

func (w *errorInterceptResponseWriter) WriteHeader(status int) {
	if status >= http.StatusBadRequest {
		w.h(w.ResponseWriter, status)
		w.h = nil
	} else {
		w.ResponseWriter.WriteHeader(status)
	}
}

func (w *errorInterceptResponseWriter) Write(p []byte) (int, error) {
	if w.h == nil {
		return len(p), nil
	}

	return w.ResponseWriter.Write(p)
}

func NewServer() http.Handler {
	router := mux.NewRouter()

	router.Handle("/maintenance", handlers.DefaultMaintenanceHandler())

	router.Handle("/en-gb/use-a-lasting-power-of-attorney", handlers.StaticMaintenanceHandler("Use a LPA English", "ual_en_maintenance.page.gohtml"))
	router.Handle("/cy/defnyddio-atwrneiaeth-arhosol", handlers.StaticMaintenanceHandler("Use a LPA Welsh", "ual_cy_maintenance.page.gohtml"))
	router.Handle("/en-gb/view-a-lasting-power-of-attorney", handlers.StaticMaintenanceHandler("View a LPA English", "val_en_maintenance.page.gohtml"))
	router.Handle("/cy/gweld-atwrneiaeth-arhosol", handlers.StaticMaintenanceHandler("View a LPA Welsh", "val_cy_maintenance.page.gohtml"))
	router.Handle("/en-gb/make-a-lasting-power-of-attorney", handlers.StaticMaintenanceHandler("Make a LPA English", "mal_en_maintenance.page.gohtml"))

	router.Handle("/en-gb/use-a-lasting-power-of-attorney/planned", handlers.StaticMaintenanceHandler("Use a LPA English Planned Downtime", "ual_en_planned_maintenance.page.gohtml"))
	router.Handle("/cy/defnyddio-atwrneiaeth-arhosol/planned", handlers.StaticMaintenanceHandler("Use a LPA Welsh Planned Downtime", "ual_cy_planned_maintenance.page.gohtml"))
	router.Handle("/en-gb/view-a-lasting-power-of-attorney/planned", handlers.StaticMaintenanceHandler("View a LPA English Planned Downtime", "val_en_planned_maintenance.page.gohtml"))
	router.Handle("/cy/gweld-atwrneiaeth-arhosol/planned", handlers.StaticMaintenanceHandler("View a LPA Welsh Planned Downtime", "val_cy_planned_maintenance.page.gohtml"))
	router.Handle("/en-gb/make-a-lasting-power-of-attorney/planned", handlers.StaticMaintenanceHandler("Make a LPA English Planned Downtime", "mal_en_planned_maintenance.page.gohtml"))

	router.PathPrefix("/").Handler(handlers.StaticHandler(os.DirFS("web/static")))

	wrap := WithJSONLogging(
		WithTemplates(
			withErrorHandling(router),
			LoadTemplates(os.DirFS("web/templates")),
		),
		log.Logger,
	)

	return wrap
}

func withErrorHandling(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var eh ErrorHandler = func(w http.ResponseWriter, i int) {
			w.WriteHeader(i)

			t := "error.page.gohtml"
			switch i {
			case 403:
				t = "notauthorised.page.gohtml"
			case 404:
				t = "notfound.page.gohtml"
			}

			ws := handlers.NewTemplateWriterService()
			if err := ws.RenderTemplate(w, r.Context(), t, nil); err != nil {
				log.Panic().Err(err).Msg("")
			}
		}

		// panic recovery
		defer func() {
			if r := recover(); r != nil {
				var err error
				switch t := r.(type) {
				case string:
					err = fmt.Errorf("%w, %s", ErrPanicRecovery, t)
				}
				log.Error().Err(err).Stack().Msg("error handler recovering from panic()")

				eh(w, http.StatusInternalServerError)
			}
		}()

		next.ServeHTTP(&errorInterceptResponseWriter{w, eh}, r)
	})
}
