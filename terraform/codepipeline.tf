resource "aws_codebuild_project" "build" {
  name         = "nodejs-app-build"
  description  = "Builds the nodejs-app"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.ecr_repository_name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = var.image_tag
    }

    environment_variable {
      name  = "REPOSITORY_ID"
      value = var.repository_id
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
  }
}

resource "aws_codepipeline" "main" {
  name     = "nodejs-app-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    
    action {
      name     = "Source"
      category = "Source"
      owner    = "AWS"
      provider = "CodeStarSourceConnection"
      version  = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn = var.codestar_connection_arn
        FullRepositoryId = var.repository_id
        BranchName = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "Build"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"
      input_artifacts = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = "nodejs-app-build"
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      owner = "AWS"
      name = "Deploy"
      category = "Deploy"
      provider = "ECS"
      region = var.aws_region
      input_artifacts = ["build_output"]
      version = "1"

      configuration = {
        ClusterName = aws_ecs_cluster.main.name 
        ServiceName = aws_ecs_service.main.name
        FileName = "imagedefinitions.json"
      }
    }
  }
}
