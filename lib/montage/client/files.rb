module Montage
  class Client
    module Files
      # Public: Get a list of files.
      #
      # Returns a Montage::Response
      def files
        get "files"
      end

      # Public: Get a single file
      #
      # file_id - Required. The uuid of the file.
      #
      # Returns a Montage::Response
      def file(file_id)
        get "files/#{file_id}"
      end

      # Public: Upload a new file
      #
      # file - Required. The file to upload.
      #
      # Returns a Montage::Response
      def new_file(file)
        post "files", file
      end

      # Public: Delete a file
      #
      # file_id - Required. The uuid of the file.
      #
      # Returns a Montage::Response
      def destroy_file(file_id)
        delete "files/#{file_id}"
      end
    end
  end
end