class TopController < ApplicationController
  def index
    @text_file = UploadedFile.new
    @uploaded_files = UploadedFile.select(:id, :file_name, :file_type).all
  end
end
