package handlers

import (
	"net/http"

	"github.com/rs/zerolog/log"
)

func DefaultMaintenanceHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		log.Ctx(r.Context()).Debug().Msg("viewed the default maintenance page")

		templateWriterService := NewTemplateWriterService()
		if err := templateWriterService.RenderTemplate(w, r.Context(), "default_maintenance.page.gohtml", nil); err != nil {
			log.Panic().Err(err).Msg(err.Error())
		}
	}
}
