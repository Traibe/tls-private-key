terraform {
  required_version = ">= 0.12"
}

resource "random_id" "name" {
  count = var.create == true ? 1 : 0

  byte_length = 4
  prefix      = "${var.name}-"
}

resource "tls_private_key" "key" {
  count = var.create == true ? 1 : 0

  algorithm   = var.algorithm
  rsa_bits    = var.rsa_bits
  ecdsa_curve = var.ecdsa_curve
}

resource "null_resource" "download_private_key" {
  count = var.create == true ? 1 : 0

  provisioner "local-exec" {
    command = "echo '${tls_private_key.key[count.index].private_key_pem}' > ${format("%s.key.pem", random_id.name[count.index].hex)} && chmod ${var.permissions} ${format("%s.key.pem", random_id.name[count.index].hex)}"
  }
}
