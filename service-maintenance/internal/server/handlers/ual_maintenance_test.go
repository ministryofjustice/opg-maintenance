package handlers_test

import (
	"os"
	"testing"

	"github.com/ministryofjustice/opg-maintenance/service-maintenance/internal/server"
	. "github.com/ministryofjustice/opg-maintenance/service-maintenance/internal/server/handlers"
	"github.com/spf13/afero"
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

func TestUseALPAEnglishMaintenanceHandler_WithBadTemplate(t *testing.T) {
	t.Parallel()

	memfs := afero.NewMemMapFs()

	err := afero.WriteFile(memfs, "test.page.gohtml", []byte(""), 0644)
	if err != nil {
		t.Fatalf("%v", err)
	}

	fs := afero.NewIOFS(memfs)

	handler := server.WithTemplates(
		UseALPAWelshMaintenanceHandler(),
		server.LoadTemplates(fs), // bad template location loads no templates
	)

	// the handler panics but that is handled upstream so it claims success at this point
	assert.HTTPSuccess(t, handler.ServeHTTP, "GET", "/en-gb/use-lasting-power-of-attorney", nil)
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

func TestUseALPAWelshMaintenanceHandler_WithBadTemplate(t *testing.T) {
	t.Parallel()

	memfs := afero.NewMemMapFs()

	err := afero.WriteFile(memfs, "test.page.gohtml", []byte(""), 0644)
	if err != nil {
		t.Fatalf("%v", err)
	}

	fs := afero.NewIOFS(memfs)

	handler := server.WithTemplates(
		UseALPAWelshMaintenanceHandler(),
		server.LoadTemplates(fs), // bad template location loads no templates
	)

	// the handler panics but that is handled upstream so it claims success at this point
	assert.HTTPSuccess(t, handler.ServeHTTP, "GET", "/cy/defnyddio-atwrneiaeth-arhosol", nil)
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

func TestViewALPAEnglishMaintenanceHandler_WithBadTemplate(t *testing.T) {
	t.Parallel()

	memfs := afero.NewMemMapFs()

	err := afero.WriteFile(memfs, "test.page.gohtml", []byte(""), 0644)
	if err != nil {
		t.Fatalf("%v", err)
	}

	fs := afero.NewIOFS(memfs)

	handler := server.WithTemplates(
		ViewALPAEnglishMaintenanceHandler(),
		server.LoadTemplates(fs), // bad template location loads no templates
	)

	// the handler panics but that is handled upstream so it claims success at this point
	assert.HTTPSuccess(t, handler.ServeHTTP, "GET", "/en-gb/view-lasting-power-of-attorney", nil)
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

func TestViewALPAWelshMaintenanceHandler_WithBadTemplate(t *testing.T) {
	t.Parallel()

	memfs := afero.NewMemMapFs()

	err := afero.WriteFile(memfs, "test.page.gohtml", []byte(""), 0644)
	if err != nil {
		t.Fatalf("%v", err)
	}

	fs := afero.NewIOFS(memfs)

	handler := server.WithTemplates(
		ViewALPAWelshMaintenanceHandler(),
		server.LoadTemplates(fs), // bad template location loads no templates
	)

	// the handler panics but that is handled upstream so it claims success at this point
	assert.HTTPSuccess(t, handler.ServeHTTP, "GET", "/cy/gweld-atwrneiaeth-arhosol", nil)
}
