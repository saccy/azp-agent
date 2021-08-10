output "ovpn_public_ip" {
    value = digitalocean_droplet.azp_agent.ipv4_address
}

output "ovpn_server_id" {
    value = digitalocean_droplet.azp_agent.id
}
