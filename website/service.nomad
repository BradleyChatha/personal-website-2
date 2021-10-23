job "personal" {
    datacenters = ["dc1"]
    type = "service"
    
    group "personal" {
        count = 1

        network {
            port "http" { to = 8080 }
        }

        service {
            port = "http"
            tags = ["reproxy.enabled=true", "reproxy.server=bradley.chatha.dev"]
        }

        task "drone" {
            driver = "docker"

            config {
                image = "bradleychatha/website"
                ports = ["http"]
                force_pull = true
            }

            resources {
                cpu = 100
                memory = 20
            }
        }
    }
}