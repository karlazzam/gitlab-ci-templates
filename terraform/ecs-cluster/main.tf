resource "aws_ecs_cluster" "this" {
  name = "${var.name}"

  tags = "${merge(var.tags, map("Name", format("%s-%d", var.name, count.index+1)))}"
}



