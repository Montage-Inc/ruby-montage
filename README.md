# Ruby Montage

A Ruby wrapper for the [Montage](https://www.foo.com) API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-montage', require: 'montage'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-montage

## Usage

In order to use the API, you will first have to retrieve an authorization token

```ruby
client = Montage::Client.new do |c|
  c.username = "YOUR_USERNAME"
  c.password = "YOUR_PASSWORD"
  c.api_version # Optional, defaults to 1
  c.domain = "test" # Your Montage subdomain
end

response = client.auth
token = response.token.value
```

This token does not expire, so it is recommended that you store this token somewhere in your database to avoid having to
make an API call to retrieve it on every request.

After retrieving a token, you can simply use the client to perform API requests:

```ruby
client.schemas
```

Or, use the same token later to initialize a new instance of the client:

```ruby
client = Montage::Client.new do |c|
  c.token = "YOUR_TOKEN"
  c.domain = "test" # Your Montage subdomain
end
```

All API actions are available as methods on the client object. The following methods are available:

## Schemas

| Action                          | Method                                              |
| :------------------------------ | :-------------------------------------------------- |
| Get a list of schemas           | `#schemas`                                          |
| Fetch a single schema           | `#schema(name)`                                    |

## Documents

| Action                              | Method                                              |
| :------------------------------     | :-------------------------------------------------- |
| Query documents in a schema         | `#documents(schema, query: query)`                  |
| Fetch a single document             | `#document(schema, document_uuid)`                  |
| Fetch the next set of documents     | `#document_cursor(schema, cursor)`                  |
| Delete a document                   | `#delete_document(schema, document_uuid)`           |
| Create or update a set of documents | `#create_or_update_documents(schema,documents)`     |


## Operators

| Operator    | Montage Equivalent |
| :-----------| :---------         |
| !=          | __not              |
| >=          | __gte              |
| <=          | __lte              |
| =           |                    |
| >           | __gt               |
| <           | __lt               |
| not in      | __notin            |
| in          | __in               |
| not in      | __notin            |
| like        | __contains         |
| ilike       | __icontains        |


## The Query Object

The Montage API requires a JSON serialized query object to query a schema

    {
      "limit": 10,
      "offset": 10,
      "order_by": "foo",
      "ordering": "asc",
      "filter": {
        ...
      }
    }

The Ruby Montage API wrapper provides a query object that has a DSL similar to that of a Rails ActiveRecord object:

```ruby
query = Montage::Query.new
query = query.where("foo > 5").limit(10).order(foo: :asc)
```

This query object can now be passed into an API call to documents to retrieve a set of documents:

```ruby
c.documents("movies", query: query)
```

Using this query object is not required in order to complete a request. Any object that responds to `.to_json` and
returns an object that conforms to the above query standards will work. This is merely provided as a convenience.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ruby-montage/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
