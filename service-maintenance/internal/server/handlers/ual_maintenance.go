package handlers

import (
	"net/http"

	"github.com/rs/zerolog/log"
)

func UseALPAEnglishMaintenanceHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		log.Ctx(r.Context()).Debug().Msg("viewed the Use a LPA English maintenance page")

		templateWriterService := NewTemplateWriterService()
		if err := templateWriterService.RenderTemplate(w, r.Context(), "ual_en_maintenance.page.gohtml", nil); err != nil {
			log.Panic().Err(err).Msg(err.Error())
		}
	}
}

func UseALPAWelshMaintenanceHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		log.Ctx(r.Context()).Debug().Msg("viewed the Use a LPA Welsh maintenance page")

		templateWriterService := NewTemplateWriterService()
		if err := templateWriterService.RenderTemplate(w, r.Context(), "ual_cy_maintenance.page.gohtml", nil); err != nil {
			log.Panic().Err(err).Msg(err.Error())
		}
	}
}

func ViewALPAEnglishMaintenanceHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		log.Ctx(r.Context()).Debug().Msg("viewed the View a LPA English  maintenance page")

		templateWriterService := NewTemplateWriterService()
		if err := templateWriterService.RenderTemplate(w, r.Context(), "val_en_maintenance.page.gohtml", nil); err != nil {
			log.Panic().Err(err).Msg(err.Error())
		}
	}
}

func ViewALPAWelshMaintenanceHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		log.Ctx(r.Context()).Debug().Msg("viewed the View a LPA Welsh maintenance page")

		templateWriterService := NewTemplateWriterService()
		if err := templateWriterService.RenderTemplate(w, r.Context(), "val_cy_maintenance.page.gohtml", nil); err != nil {
			log.Panic().Err(err).Msg(err.Error())
		}
	}
}
