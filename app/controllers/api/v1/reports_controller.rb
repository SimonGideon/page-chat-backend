module Api
  module V1
    class ReportsController < ApplicationController
      before_action :authenticate_user!

      def create
        report = Report.new(report_params)
        report.reporter = current_user

        if report.save
          render json: { message: "Report submitted successfully." }, status: :created
        else
          render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def report_params
        params.require(:report).permit(:reportable_id, :reportable_type, :reason)
      end
    end
  end
end
