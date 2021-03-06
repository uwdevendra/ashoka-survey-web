##= require ./question_view

class SurveyBuilderV2.Views.RightPane.MultilineQuestionView extends SurveyBuilderV2.Views.RightPane.QuestionView
  events:
    "change .question-answer-type-select": "updateView"
    "change .question-content-textarea": "updateModelContent"
    "click .question-settings input": "updateModelSettings"
    "click .question-update": "saveQuestion"

  updateModelContent: (event) =>
    content = $(event.target).val()
    @model.set(content: content)

  viewType: =>
    "MultilineQuestion"
