# opg-maintenance

The Office of the Public Guardian maintenance service: Managed by opg-org-infra &amp; Terraform

A service that serves maintenance pages for other OPG digital services using the GOV.UK design system.

## Useage

Create templates and routing to deploy a page for your service.

Templates are in `service-maintenance/web/templates`.

Routers are added to `service-maintenance/internal/server/server.go`.

So to create a new maintenance page create a new template `service-maintenance/web/templates/my_service_maintenance.page.gohtml`

```go
{{ template "default" . }}

{{ define "title" }}My Service{{ end }}

{{ define "main" }}
  <h1 class="govuk-heading-xl">Sorry, My Service is unavailable</h1>
  <p class="govuk-body">My Service will be restored shortly</p>
{{ end }}
```

And add a new router for it in `service-maintenance/internal/server/server.go`

```go
router.Handle("/my-service", handlers.StaticMaintenanceHandler("My Service", "my_service_maintenance.page.gohtml"))
```
