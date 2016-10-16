# Nested Form Fields [![Build Status](https://secure.travis-ci.org/ncri/nested_form_fields.png)](http://travis-ci.org/ncri/nested_form_fields)

This Rails gem helps creating forms for models with nested has_many associations.

It uses jQuery to dynamically add and remove nested associations.

- Works for arbitrarily deeply nested associations (tested up to 4 levels).
- Works with form builders like [simple_form](https://github.com/plataformatec/simple_form).
- Requires Ruby 1.9+ and the Rails asset pipeline.



## Installation

Add this line to your application's Gemfile:

    gem 'nested_form_fields'

And then execute:

    $ bundle

In your application.js file add:

    //= require nested_form_fields

## Usage

Assume you have a user model with nested videos:

```ruby
class User < ActiveRecord::Base
  has_many :videos
  accepts_nested_attributes_for :videos, allow_destroy: true
end
```

Use the `nested_fields_for` helper inside your user form to add the video fields:

```haml
= form_for @user do |f|
  = f.nested_fields_for :videos do |ff|
    = ff.text_field :video_title
    ..
```

Links to add and remove fields can be added using the `add_nested_fields_link` and `remove_nested_fields_link` helpers:

```haml
= form_for @user do |f|
  = f.nested_fields_for :videos do |ff|
    = ff.remove_nested_fields_link
    = ff.text_field :video_title
    ..
  = f.add_nested_fields_link :videos
```

Note that `remove_nested_fields_link` needs to be called within the `nested_fields_for` call and `add_nested_fields_link` outside of it via the parent builder.

## Link Customization

You can change the link text of `remove_nested_fields_link` and `add_nested_fields_link` like this:

```haml
...
  ff.remove_nested_fields_link 'Remove me'
  ...
f.add_nested_fields_link :videos, 'Add another funtastic video'
```

You can add classes/attributes to the  `remove_nested_fields_link` and `add_nested_fields_link` like this:

```haml
...
  ff.remove_nested_fields_link 'Remove me', class: 'btn btn-danger', role: 'button'
  ...
f.add_nested_fields_link :videos, 'Add another funtastic video', class: 'btn btn-primary', role: 'button'
```

You can supply a block to the `remove_nested_fields_link` and the `add_nested_fields_link` helpers, as you can with `link_to`:

```haml
= ff.remove_nested_fields_link do
  Remove me %span.icon-trash
```

You can add a `data-confirm` attribute to the `remove_nested_fields_link` if you want the user to confirm whenever they remove a nested field:

```haml
= ff.remove_nested_fields_link 'Remove me', data: { confirm: 'Are you sure?' }
```

## Custom Container

You can specify a custom container to add nested forms into, by supplying an id via the `data-insert-into` attribute of the `add_nested_fields_link`:

```haml
f.add_nested_fields_link :videos, 'Add another funtastic video', data: { insert_into: '<container_id>' }
```

## Custom Fields Wrapper

You can change the type of the element wrapping the nested fields using the `wrapper_tag` option:

```haml
= f.nested_fields_for :videos, wrapper_tag: :div do |ff|
```

The default wrapper element is a fieldset. To add legend element to the fieldset use:

```haml
= f.nested_fields_for :videos, legend: "Video" do |ff|
```

You can pass options like you would to the `content_tag` method by nesting them in a `:wrapper_options` hash:

```haml
= f.nested_fields_for :videos, wrapper_options: { class: 'row' } do |ff|
```

## Rails 4 Parameter Whitelisting

If you are using Rails 4 remember to add {{ NESTED_MODEL }}_attributes and the attributes to the permitted params.
If you want to destroy the nested model you should add `:_destroy` and `:id`.
For example:

```haml
# app/views/users/_form.haml.erb
= form_for @user do |f|
  = f.nested_fields_for :videos do |ff|
    = ff.remove_nested_fields_link
    = ff.text_field :video_title
    ..
  = f.add_nested_fields_link :videos
```

```ruby
# app/controllers/users_controller
..
def user_params
    params.require(:user)
        .permit(:name,:email,videos_attributes:[:video_title,:_destroy,:id])
#                            ^^^                 ^^^           ^^^
#                            nested model attrs
#                                                             they will let you delete the nested model
end
```

## Events

There are four JavaScript events firing before and after addition/removal of the fields in the `nested_form_fields` namespace:

- `fields_adding`
- `fields_added`
- `fields_removing`
- `fields_removed`

The events `fields_added` and `fields_removed` are triggered on the element being added or removed. The events bubble up so you can listen for them on any parent element.
This makes it easy to add listeners when you have multiple `nested_form_fields` on the same page.

CoffeeScript samples:

```coffeescript
# Listen on an element
initializeSortable -> ($el)
  $el.sortable(...)
  $el.on 'fields_added.nested_form_fields', (event, param) ->
    console.log event.target # The added field
    console.log $(this)      # $el

# Listen on document
$(document).on "fields_added.nested_form_fields", (event, param) ->
  switch param.object_class
    when "video"
      console.log "Video object added"
    else
      console.log "INFO: Fields were successfully added, callback not handled."
```

You can pass any additional data to the event's callback. This may be useful if you trigger them programmatically. Example:

```coffeescript
# Trigger button click programmatically and pass an object `{hello: 'world'}`
$('.add_nested_fields_link').trigger('click', [{hello: 'world'}])

# Listen for the event
$(document).on "fields_added.nested_form_fields", (event, param) ->
  console.log param.additional_data #=> {hello: 'world'}
```

## Index replacement string

Sometimes your code needs to know what index it has when it is instantiated onto the page.
HTML data elements may need to point to other form elements for instance. This is needed for integration
with rails3-jquery-autocomplete.

To enable string substitution with the current index use the magic string `__nested_field_for_replace_with_index__`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Contributers

https://github.com/ncri/nested_form_fields/graphs/contributors
