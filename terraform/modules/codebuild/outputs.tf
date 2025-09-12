# ================================================================
# CODEBUILD MODULE OUTPUTS
# These outputs are used by other modules
# ================================================================

output "codebuild_project_names" {
  description = "Map of CodeBuild project names"
  value = {
    for k, project in aws_codebuild_project.services : k => project.name
  }
}

output "codebuild_project_arns" {
  description = "Map of CodeBuild project ARNs"
  value = {
    for k, project in aws_codebuild_project.services : k => project.arn
  }
}

output "codebuild_projects" {
  description = "Complete CodeBuild project details"
  value = {
    for k, project in aws_codebuild_project.services : k => {
      name = project.name
      arn  = project.arn
    }
  }
}