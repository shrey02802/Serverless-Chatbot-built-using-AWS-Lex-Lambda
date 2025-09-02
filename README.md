# Serverless Chatbot built using AWS Lex Lambda

This project demonstrates a serverless chatbot using AWS Lex V2 and Lambda, automated via Terraform. The chatbot handles user queries for order tracking, status checks, and destinations using defined intents and slot values.

It provides a structured and interactive experience, perfect for customer support workflows, FAQs, or order tracking scenarios, without requiring AI or machine learning.

File Structure:

chatbot-terraform/
    ├── main.tf           # Main resources for bot and integration
    ├── provider.tf       # AWS provider configuration
    ├── iamrole.tf        # IAM role and permissions for Lambda
    ├── lambda_function/  # Folder containing lambda_function.py (zip file)


Advantages:

    Serverless architecture → No server management required.
    
    Infrastructure as Code → Fully automated deployment using Terraform.
    
    Reusable and extendable → Easily add new intents, slots, or utterances.
    
    Easy testing → Direct testing in AWS Lex console.
    
    CloudWatch integration → Monitor Lambda execution and chatbot usage.

Steps to Run:

Clone the repository:

    git clone <repo-url>
    cd chatbot-terraform


Build the Lambda zip (if not already zipped):

    cd lambda_function
    zip lambda_function.zip lambda_function.py
    cd ..


Initialize Terraform:

    terraform init


Apply Terraform configuration:

    terraform apply


Once deployed, go to the AWS Lex Console, select your bot alias, and test the queries directly.

Monitor Lambda execution using CloudWatch Logs.

Note: The chatbot responds to defined utterances and slots. It is ideal for structured workflows where AI is not required.
