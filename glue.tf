
resource "aws_glue_catalog_database" "sales_database" {
  name = "sales"
}

resource "aws_glue_classifier" "aws_glue_csv_classifier" {
  name = "csv-classifier"

  csv_classifier {
    header = ["PRODUCT_NAME", "COUNTRY", "PRICE", "QUANTITY"]
    contains_header = "ABSENT"
    quote_symbol = "\""
    delimiter = ","
  }
}

resource "aws_glue_crawler" "aws_glue_custom_csv_crawler" {
  name = "custom-csv-crawler"
  database_name = aws_glue_catalog_database.sales_database.name
  classifiers = [aws_glue_classifier.aws_glue_csv_classifier.id]
  role = aws_iam_role.aws_iam_glue_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.bucket_for_glue.bucket}/sales/"
  }
  
  provisioner "local-exec" {
    #command = "aws s3 cp ./custom_data.csv s3://atin-aws-glue-etl-process/sales/custom_data.csv;aws glue start-crawler --name ${self.name}"
  command = "aws s3 cp ./custom_data.csv s3://${var.bucket_for_glue}/sales/custom_data.csv;aws glue start-crawler --name ${self.name}"
  }
  
}

