resource "postgresql_role" "dub_updater" {
  name     = "dub_updater"
  password = var.dub_updater_password
  login    = true
}

resource "postgresql_database" "dub_stats" {
  name  = "dub_stats"
  owner = postgresql_role.dub_updater.name
}
