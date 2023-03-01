resource "aws_iam_user" "multi-user" {
    count = "10"
    name = "shubham.${count.index+11}"
    tags = {
        Name = "shubham"
    }
}