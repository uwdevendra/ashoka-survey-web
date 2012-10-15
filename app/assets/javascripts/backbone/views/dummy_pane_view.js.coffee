# Collection of dummy questions
class SurveyBuilder.Views.DummyPaneView extends Backbone.View
  el: "#dummy_pane"

  events:
    'add_dummy_sub_question': 'add_sub_question'

  initialize: (survey_model) ->
    @questions = []
    @survey_model = survey_model
    @add_survey_details(survey_model)
    ($(this.el).find("#dummy_questions")).sortable({update : this.reorder_questions})

  add_question: (type, model, parent) ->
    insert_at_index = @questions.indexOf(_(@questions).find((view) ->
      view.model.get('options').contains(parent) if view.model.get('options')
    ))

    switch type
      when 'SingleLineQuestion'
        template = $('#dummy_single_line_question_template').html()
        @insert_view_at_index(new SurveyBuilder.Views.Dummies.QuestionView(model, template), insert_at_index)
      when 'MultilineQuestion'
        template = $('#dummy_multiline_question_template').html()
        @insert_view_at_index(new SurveyBuilder.Views.Dummies.QuestionView(model, template), insert_at_index)
      when 'NumericQuestion'
        template = $('#dummy_numeric_question_template').html()
        @insert_view_at_index(new SurveyBuilder.Views.Dummies.QuestionView(model, template), insert_at_index)
      when 'DateQuestion'
        template = $('#dummy_date_question_template').html()
        @insert_view_at_index(new SurveyBuilder.Views.Dummies.QuestionView(model, template), insert_at_index)
      when 'RadioQuestion'
        template = $('#dummy_radio_question_template').html()
        @insert_view_at_index(new SurveyBuilder.Views.Dummies.QuestionWithOptionsView(model, template), insert_at_index)
      when 'MultiChoiceQuestion'
        template = $('#dummy_multi_choice_question_template').html()
        @insert_view_at_index(new SurveyBuilder.Views.Dummies.QuestionWithOptionsView(model, template), insert_at_index)
      when 'DropDownQuestion'
        template = $('#dummy_drop_down_question_template').html()
        @insert_view_at_index(new SurveyBuilder.Views.Dummies.QuestionWithOptionsView(model, template), insert_at_index)
      when 'PhotoQuestion'
        template = $('#dummy_photo_question_template').html()
        @insert_view_at_index(new SurveyBuilder.Views.Dummies.QuestionView(model, template), insert_at_index)
      when 'RatingQuestion'
        template = $('#dummy_rating_question_template').html()
        @insert_view_at_index(new SurveyBuilder.Views.Dummies.QuestionView(model, template), insert_at_index)

    model.on('destroy', this.delete_question_view, this)
    this.render()

  insert_view_at_index: (view, index) ->
    if index == -1
      @questions.push(view)
    else
      @questions.splice(index + 1, 0, view)

  add_survey_details: (survey_model) ->
    template = $("#dummy_survey_details_template").html()
    @dummy_survey_details = new SurveyBuilder.Views.Dummies.SurveyDetailsView({ model: survey_model, template: template})

  render: ->
    ($(this.el).find("#dummy_survey_details").append(@dummy_survey_details.render().el)) 
    ($(this.el).find("#dummy_questions").append(question.render().el)) for question in @questions 
    return this

  unfocus_all: ->
    $(@dummy_survey_details.el).removeClass("active")
    $(question.el).removeClass("active") for question in @questions

  delete_question_view: (model) ->
    question = _(@questions).find((question) -> question.model == model )
    @questions = _(@questions).without(question)
    question.remove()

  reorder_questions: (event, ui) =>
    survey_model = @survey_model
    question_views = @questions
    next_order_number = survey_model.next_order_number()
    ($(this.el).find("#dummy_questions").children("div")).each (i) ->
      id = parseInt( $(this).attr("id") )
      question_view = _.find(question_views, (question) ->
        question.id is id
      )
      question_model = question_view.model
      question_model.set({order_number: i + 1 + next_order_number})

  add_sub_question: (event, sub_question_model) =>
    template = $('#dummy_single_line_question_template').html()
    question = new SurveyBuilder.Views.Dummies.QuestionView(sub_question_model, template)
    this.questions.push question
    this.render()
