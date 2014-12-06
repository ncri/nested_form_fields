window.nested_form_fields or= {}

nested_form_fields.bind_nested_forms_links = () ->
  $('body').off("click", '.add_nested_fields_link')
  $('body').on 'click', '.add_nested_fields_link', ->
    $link = $(this)
    object_class = $link.data('object-class')
    $.event.trigger("fields_adding.nested_form_fields",{object_class: object_class});
    association_path = $link.data('association-path')
    $template = $("##{association_path}_template")

    template_html = $template.html()

    # insert association indexes
    index_placeholder = "__#{association_path}_index__"
    template_html = template_html.replace(new RegExp(index_placeholder,"g"), $(".nested_#{association_path}").length)

    # replace child template div tags with script tags to avoid form submission of templates
    $parsed_template = $(template_html)
    $child_templates = $parsed_template.closestChild('.form_template')
    $child_templates.each () ->
      $child = $(this)
      $child.replaceWith($("<script id='#{$child.attr('id')}' type='text/html' />").html($child.html()))

    $template.before( $parsed_template )
    $.event.trigger("fields_added.nested_form_fields",{object_class: object_class});
    false

  $('body').off("click", '.remove_nested_fields_link')
  $('body').on 'click', '.remove_nested_fields_link', ->
    $link = $(this)
    object_class = $link.data('object-class')
    $.event.trigger("fields_removing.nested_form_fields",{object_class: object_class});
    delete_association_field_name = $link.data('delete-association-field-name')
    $nested_fields_container = $link.parents(".nested_fields").first()
    $nested_fields_container.before "<input type='hidden' name='#{delete_association_field_name}' value='1' />"
    $nested_fields_container.hide()
    $nested_fields_container.find('input[required]:hidden').removeAttr('required')
    $.event.trigger("fields_removed.nested_form_fields",{object_class: object_class});
    false

$(document).on "page:change", ->
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

