window.nested_form_fields or= {}

nested_form_fields.bind_nested_forms_links = () ->
  $('body').off("click", '.add_nested_fields_link')
  $('body').on 'click', '.add_nested_fields_link', (event, additional_data) ->
    $link = $(this)
    object_class = $link.data('object-class')
    association_path = $link.data('association-path')
    added_index = $(".nested_#{association_path}").length
    $.event.trigger("fields_adding.nested_form_fields",{object_class: object_class, added_index: added_index, association_path: association_path, additional_data: additional_data});
    if $link.data('scope')
      $template = $("#{$link.data('scope')} ##{association_path}_template")
    else
      $template = $("##{association_path}_template")
    target = $link.data('insert-into')

    template_html = $template.html()

    # insert association indexes
    index_placeholder = "__#{association_path}_index__"
    template_html = template_html.replace(new RegExp(index_placeholder,"g"), added_index)
	# look for replacements in user defined code and substitute with the index
    template_html = template_html.replace(new RegExp("__nested_field_for_replace_with_index__","g"), added_index)

    # replace child template div tags with script tags to avoid form submission of templates
    $parsed_template = $(template_html)
    $child_templates = $parsed_template.closestChild('.form_template')
    $child_templates.each () ->
      $child = $(this)
      $child.replaceWith($("<script id='#{$child.attr('id')}' type='text/html' />").html($child.html()))

    if target?
      $('#' + target).append($parsed_template)
    else
      $template.before( $parsed_template )
    $parsed_template.trigger("fields_added.nested_form_fields", {object_class: object_class, added_index: added_index, association_path: association_path, event: event, additional_data: additional_data});
    false

  $('body').off("click", '.remove_nested_fields_link')
  $('body').on 'click', '.remove_nested_fields_link', ->
    $link = $(this)
    return false unless $.rails.allowAction($link)
    object_class = $link.data('object-class')
    delete_association_field_name = $link.data('delete-association-field-name')
    removed_index = parseInt(delete_association_field_name.match('(\\d+\\]\\[_destroy])')[0].match('\\d+')[0])
    $.event.trigger("fields_removing.nested_form_fields",{object_class: object_class, delete_association_field_name: delete_association_field_name, removed_index: removed_index });
    $nested_fields_container = $link.parents(".nested_fields").first()
    delete_field = $nested_fields_container.find("input[type='hidden'][name='#{delete_association_field_name}']")
    if delete_field.length > 0
      delete_field.val('1')
    else
      $nested_fields_container.before "<input type='hidden' name='#{delete_association_field_name}' value='1' />"
    $nested_fields_container.hide()
    $nested_fields_container.find('input[required]:hidden, select[required]:hidden, textarea[required]:hidden').removeAttr('required')
    $nested_fields_container.trigger("fields_removed.nested_form_fields",{object_class: object_class, delete_association_field_name: delete_association_field_name, removed_index: removed_index});
    false

$(document).on "page:change turbolinks:load", ->
    nested_form_fields.bind_nested_forms_links()

jQuery ->
    nested_form_fields.bind_nested_forms_links()


#
# * jquery.closestchild 0.1.1
# *
# * Author: Andrey Mikhaylov aka lolmaus
# * Email: lolmaus@gmail.com
# *
#

$.fn.closestChild = (selector) ->
  $children = undefined
  $results = undefined
  $children = @children()
  return $() if $children.length is 0
  $results = $children.filter(selector)
  if $results.length > 0
    $results
  else
    $children.closestChild selector
