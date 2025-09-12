# ================================================================
# CODEPIPELINE MODULE OUTPUTS
# ================================================================

output "pipeline_names" {
  description = "Map of CodePipeline names"
  value = {
    for k, pipeline in aws_codepipeline.services : k => pipeline.name
  }
}

output "pipeline_arns" {
  description = "Map of CodePipeline ARNs"
  value = {
    for k, pipeline in aws_codepipeline.services : k => pipeline.arn
  }
}

output "pipelines" {
  description = "Complete CodePipeline details"
  value = {
    for k, pipeline in aws_codepipeline.services : k => {
      name = pipeline.name
      arn  = pipeline.arn
    }
  }
}