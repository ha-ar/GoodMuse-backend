
json.question  do

  json.id                 @question.id
  json.question           @question.question
  json.answer             @question.answer
  json.created_at         @question.created_at
  json.updated_at         @question.updated_at

end

json.success true