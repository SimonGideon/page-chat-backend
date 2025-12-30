module Api
  module V1
    class ReadingPositionsController < ApplicationController
      before_action :authenticate_user!

      def update
        book = Book.find(params[:book_id])
        reading_position = current_user.reading_positions.find_or_initialize_by(book: book)

        if reading_position.update_position!(
             page: params[:page_number],
             scroll_offset: params[:scroll_offset],
             percentage: params[:percentage_completed]
           )
          render json: {
            status: { code: 200, message: "Reading position saved." },
            data: {
              page_number: reading_position.page_number,
              scroll_offset: reading_position.scroll_offset,
              updated_at: reading_position.updated_at
            }
          }, status: :ok
        else
          render json: {
            status: { code: 422, message: "Failed to save reading position." },
            errors: reading_position.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
