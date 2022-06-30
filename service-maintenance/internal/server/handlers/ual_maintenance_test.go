package handlers_test

import (
	"os"
	"testing"

	"github.com/ministryofjustice/opg-maintenance/service-maintenance/internal/server"
	. "github.com/ministryofjustice/opg-maintenance/service-maintenance/internal/server/handlers"
	"github.com/stretchr/testify/assert"
)

func TestUseALPAEnglishMaintenanceHandler(t *testing.T) {
	t.Parallel()

	handler := server.WithTemplates(
		UseALPAEnglishMaintenanceHandler(),
		server.LoadTemplates(os.DirFS("../../../web/templates")),
	)

	assert.HTTPSuccess(t, handler.ServeHTTP, "GET", "/en-gb/use-lasting-power-of-attorney", nil)
	assert.HTTPBodyContains(t, handler.ServeHTTP, "GET", "/en-gb/use-lasting-power-of-attorney", nil, "Use a lasting power of attorney")
}

func TestUseALPAWelshMaintenanceHandler(t *testing.T) {
	t.Parallel()

	handler := server.WithTemplates(
		UseALPAWelshMaintenanceHandler(),
		server.LoadTemplates(os.DirFS("../../../web/templates")),
	)

	assert.HTTPSuccess(t, handler.ServeHTTP, "GET", "/cy/defnyddio-atwrneiaeth-arhosol", nil)
	assert.HTTPBodyContains(t, handler.ServeHTTP, "GET", "/cy/defnyddio-atwrneiaeth-arhosol", nil, "Defnyddio atwrneiaeth arhosol")
}
func TestViewALPAEnglishMaintenanceHandler(t *testing.T) {
	t.Parallel()

	handler := server.WithTemplates(
		ViewALPAEnglishMaintenanceHandler(),
		server.LoadTemplates(os.DirFS("../../../web/templates")),
	)

	assert.HTTPSuccess(t, handler.ServeHTTP, "GET", "/en-gb/view-lasting-power-of-attorney", nil)
	assert.HTTPBodyContains(t, handler.ServeHTTP, "GET", "/en-gb/view-lasting-power-of-attorney", nil, "View a lasting power of attorney")
}
func TestViewALPAWelshMaintenanceHandler(t *testing.T) {
	t.Parallel()

	handler := server.WithTemplates(
		ViewALPAWelshMaintenanceHandler(),
		server.LoadTemplates(os.DirFS("../../../web/templates")),
	)

	assert.HTTPSuccess(t, handler.ServeHTTP, "GET", "/cy/gweld-atwrneiaeth-arhosol", nil)
	assert.HTTPBodyContains(t, handler.ServeHTTP, "GET", "/cy/gweld-atwrneiaeth-arhosol", nil, "Gweld atwrneiaeth arhosol")
}
