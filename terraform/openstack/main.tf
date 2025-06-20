provider "openstack" {}

resource "openstack_objectstorage_container_v1" "csv" {
  name = "csv"
}
