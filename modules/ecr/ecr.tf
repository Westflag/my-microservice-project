resource "aws_ecr_repository" "repo" { name = var.ecr_name image_scanning_configuration { scan_on_push = var.scan_on_push } }
resource "aws_ecr_repository_policy" "repo_policy" { repository = aws_ecr_repository.repo.name policy = jsonencode({Version="2008-10-17",Statement=[]}) }
