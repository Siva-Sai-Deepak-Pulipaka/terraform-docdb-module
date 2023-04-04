resource "aws_docdb_cluster" "main" {
  cluster_identifier      = "${var.env}-docdb"
  engine                  = var.engine
  engine_version          = var.engine_version
  master_username         = data.aws_ssm_parameter.user.value
  master_password         = data.aws_ssm_parameter.pass.value
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  db_subnet_group_name    = aws_docdb_subnet_group.main.name
  kms_key_id              = data.aws_kms_key.key.arn
  storage_encrypted       = var.storage_encrypted
}

# document db works only when there is instance
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "docdb-cluster-demo-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = "db.r5.large"
}

# creating subnet group for azones
resource "aws_docdb_subnet_group" "main" {
  name       = "${var.env}-docdb"
  db_subnet_ids = var.db_subnet_ids

  tags = merge(
    var.tags,
    { Name = "${var.env}-subnet-group" }
  )
}