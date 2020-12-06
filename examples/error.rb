# frozen_string_literal: true

require_relative "../lib/tty/logger"

logger = TTY::Logger.new(fields: { app: "myapp", env: "prod" })

begin
  raise ArgumentError, "Wrong data"
rescue => ex
  error = ex
  logger.fatal("Error:", error)
end
