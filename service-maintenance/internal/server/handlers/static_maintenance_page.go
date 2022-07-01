package handlers

import (
	"fmt"
	"net/http"

	"github.com/rs/zerolog/log"
)

func StaticMaintenanceHandler(PageTitle string, Template string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		log.Ctx(r.Context()).Debug().Msg(fmt.Sprintf("viewed the %s maintenance page", PageTitle))

		templateWriterService := NewTemplateWriterService()
		if err := templateWriterService.RenderTemplate(w, r.Context(), Template, nil); err != nil {
			log.Panic().Err(err).Msg(err.Error())
		}
	}
}
