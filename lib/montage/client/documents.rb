module Montage
  class Client
    module Documents
      # Public: Get a list of documents
      #
      # Params:
      #   schema - *Required* The name of the schema to run the query against
      #   query  - *Optional* A Montage::Query object to pass along with the request
      #
      # Returns a Montage::Response
      #
      def documents(schema, query = {})
        post("schemas/#{schema}/query/", "document", query)
      end

      # Public: Fetch a document
      #
      # Params:
      #   schema        - *Required* The name of the schema to fetch the document from
      #   document_uuid - *Required* The uuid of the document to fetch
      #
      # Returns a Montage::Response
      #
      def document(schema, document_uuid)
        get("schemas/#{schema}/#{document_uuid}/", "document")
      end

      # Public: Get the set of documents for the given cursor
      #
      # Params:
      #   schema - *Required* The name of the schema to run the query against
      #   cursor - *Required* The cursor that was returned in the last document API call
      #
      # Returns a Montage::Response
      #
      # def document_cursor(schema, cursor)
        # get("schemas/#{schema}/?cursor=#{cursor}", "document")
      # end

      # Public: Create or update a set of documents
      #
      # Params:
      #   schema   - *Required* The name of the schema to add the document to
      #   document - *Required* The Hash representation of the document you would like to create
      #
      # The document must conform to the schema definition
      #
      # Returns a Montage::Response
      def create_or_update_documents(schema, documents)
        post("schemas/#{schema}/save/", "document", documents)
      end

      # Public: Update a document
      #
      # Params:
      #   schema        - *Required* The name of the schema the document belongs to
      #   document_uuid - *Required* The uuid of the document you wish to update
      #   document      - *Required* The Hash representation of the document you would like to update
      #
      # The document must conform to the schema definition
      #
      # Returns a Montage::Response
      def update_document(schema, document)
        post("schemas/#{schema}/save/", "document", document)
      end

      # Public: Delete a document
      #
      # Params:
      #   schema        - *Required* The name of the schema the document belongs to
      #   document_uuid - *Required* The uuid of the document you widh to delete
      #
      # Returns a Montage::Response
      def delete_document(schema, document_uuid)
        delete("schemas/#{schema}/#{document_uuid}/", "document")
      end
    end
  end
end
