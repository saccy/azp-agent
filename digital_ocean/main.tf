provider "digitalocean" {}

#variable "location" {}
#variable "ssh" {}

# Create a new SSH key
resource "digitalocean_ssh_key" "azp_public_key" {
    name       = "azp_public_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCR1HsSRi1OqzHEEo0XggoD2+nSDbBC0U5SN48LlDHJXd2nH6GLACjs32nmoGfTeua07TVB3tpQzoOlnDzcj8BVNqLk74e99YjDyAQDuQglFCoPYX3fQTad0Za7xKYh+sfEIJDngJ4g/tCOXxcUBMKdNEzns2MvOn6cOCZT/2kTw17RiN26cEl6S2sIpvmYBkxcj7kzDUyZbCeuamM88Wocyg3qhqbdEgUbZmCTMdpqdOnRCpppuTrhnMixxbbbdpwUfzLrwSvZzKZvYSzpVOsvg0QZCLEem5yVOVsBiLW6fSL5Lh0g1OVd97Q1YPvoQKrPsTC8j/mCin8YUyolOZpn"
}

# Create a new Droplet using the SSH key
resource "digitalocean_droplet" "azp_agent" {
    image     = "centos-7-x64"
    name      = "azp_agent"
    region    = "sgp1"
    size      = "s-1vcpu-1gb"
    ssh_keys  = [digitalocean_ssh_key.azp_public_key.fingerprint]
    # user_data = file("${path.module}/templates/run_ovpn.sh.tmpl")
}

resource "digitalocean_firewall" "azp_agent" {
    name = "only-22-and-443"

    droplet_ids = [digitalocean_droplet.azp_agent.id]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    inbound_rule {
        protocol         = "tcp"
        port_range       = "443"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
        protocol = "icmp"
    }
    outbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }
    outbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }
}
