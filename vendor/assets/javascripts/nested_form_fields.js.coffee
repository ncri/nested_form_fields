jQuery ->

  $('body').on 'click', '.add_nested_fields_link', ->
    $link = $(this)
    association_path = $link.data('association-path')
    $template = $("##{association_path}_template")

    template_html = $template.html()

    # insert association indexes
    index_placeholder = "__#{association_path}_index__"
    template_html = template_html.replace(new RegExp(index_placeholder,"g"), $(".nested_#{association_path}").length)

    # replace child template div tags with script tags to avoid form submission of templates
    $parsed_template = $(template_html)
    $child_templates = $parsed_template.children('.form_template')
    $child_templates.each () ->
      $child = $(this)
      $child.replaceWith($("<script id='#{$child.attr('id')}' type='text/html' />").html($child.html()))

    $link.before( $parsed_template )
    false


  $('body').on 'click', '.remove_nested_fields_link', ->
    $link = $(this)
    delete_association_field_name = $link.data('delete-association-field-name')
    $nested_fields_container = $link.parents(".nested_fields").first()
    $nested_fields_container.before "<input type='hidden' name='#{delete_association_field_name}' value='1' />"
    $nested_fields_container.hide()
    false