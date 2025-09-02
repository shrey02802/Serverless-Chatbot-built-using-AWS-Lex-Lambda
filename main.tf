resource "aws_lambda_function" "lex_handler" {
  function_name="lexOrderhandler"
  role = aws_iam_role.lambda_exec.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"

  filename = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_lambda_permission" "allow_lex" {
  statement_id  = "AllowLexInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lex_handler.function_name
  principal     = "lex.amazonaws.com"
  depends_on = [aws_lambda_function.lex_handler]
}


resource "aws_lexv2models_bot" "chabot" {
  name = "CustomersupportBot"
  description = "To let people ask any questions"
  role_arn = aws_iam_role.lambda_exec.arn
  
  data_privacy {
    child_directed = false 
  }

  idle_session_ttl_in_seconds = 300
}

resource "aws_lexv2models_bot_locale" "chatnot_en" {
  bot_id = aws_lexv2models_bot.chabot.id
  bot_version = "DRAFT"
  locale_id = "en_US"  
   depends_on = [aws_lexv2models_bot.chabot]
  n_lu_intent_confidence_threshold = 0.40
}

resource "aws_lexv2models_intent" "check_order" {
  bot_id =aws_lexv2models_bot.chabot.id
  bot_version = "DRAFT"
  locale_id = aws_lexv2models_bot_locale.chatnot_en.locale_id
  name = "CheckOrderStatus"
   depends_on = [aws_lexv2models_bot_locale.chatnot_en]
  sample_utterance {
    utterance = "where si my order?"
  }

  sample_utterance {
    utterance = "track my order"
  }

  fulfillment_code_hook {
    enabled = true
  }
}

resource "aws_lexv2models_slot_type" "order_id_type" {
  bot_id     = aws_lexv2models_bot.chabot.id
  bot_version = "DRAFT"
  locale_id   = aws_lexv2models_bot_locale.chatnot_en.locale_id
  name        = "OrderIdType"

   slot_type_values {
    sample_value {
      value = "12345"
    }
  }

  slot_type_values {
    sample_value {
      value = "67890"
    }
  }

  value_selection_setting {
    resolution_strategy = "OriginalValue"
  }
}


resource "aws_lexv2models_slot" "order_id" {
  bot_id = aws_lexv2models_bot.chabot.id
  bot_version = "DRAFT"
  locale_id = aws_lexv2models_bot_locale.chatnot_en.locale_id
  intent_id = aws_lexv2models_intent.check_order.intent_id
  depends_on = [aws_lexv2models_intent.check_order]
  name = "Order_ID"
  slot_type_id = aws_lexv2models_slot_type.order_id_type.slot_type_id

  value_elicitation_setting {
    slot_constraint = "Required"

    prompt_specification {
      message_selection_strategy = "Random" 

      max_retries = 2

      message_group {
        message{
          plain_text_message {
            value = "whats your problem"
          }
        }
      }
      allow_interrupt = true
    }
  }
}