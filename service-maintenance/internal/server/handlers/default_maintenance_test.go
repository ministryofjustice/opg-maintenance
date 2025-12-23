package handlers_test

import (
	"net/http/httptest"
	"os"
	"testing"

	"github.com/ministryofjustice/opg-maintenance/service-maintenance/internal/server"
	. "github.com/ministryofjustice/opg-maintenance/service-maintenance/internal/server/handlers"
	"github.com/spf13/afero"
	"github.com/stretchr/testify/assert"
)

func TestDefaultMaintenanceHandler(t *testing.T) {
	t.Parallel()

	handler := server.WithTemplates(
		DefaultMaintenanceHandler(),
		server.LoadTemplates(os.DirFS("../../../web/templates")),
	)

	assert.HTTPSuccess(t, handler.ServeHTTP, "GET", "/maintenance", nil)
	assert.HTTPBodyContains(t, handler.ServeHTTP, "GET", "/maintenance", nil, "Maintenance")
}

func TestDefaultMaintenanceHandler_WithBadTemplate(t *testing.T) {
	t.Parallel()

	memfs := afero.NewMemMapFs()

	err := afero.WriteFile(memfs, "test.page.gohtml", []byte(""), 0644)
	if err != nil {
		t.Fatalf("%v", err)
	}

	fs := afero.NewIOFS(memfs)

	handler := server.WithTemplates(
		DefaultMaintenanceHandler(),
		server.LoadTemplates(fs), // bad template location loads no templates
	)

	assert.Panics(t, func() {
		handler.ServeHTTP(httptest.NewRecorder(), httptest.NewRequest("GET", "/maintenance", nil))
	})
}
