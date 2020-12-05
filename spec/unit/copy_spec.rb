# frozen_string_literal: true

RSpec.describe TTY::Logger, "#copy" do
  let(:output) { StringIO.new }
  let(:styles) { TTY::Logger::Handlers::Console::STYLES }

  it "copies ouptut, fields and configuration over to child logger" do
    logger = TTY::Logger.new(
      output: output,
      fields: {app: "parent", env: "prod"}) do |config|
        config.handlers = [[:console, enable_color: true]]
      end
    child_logger = logger.copy(app: "child") do |config|
      config.filters.message = ["logging"]
    end

    logger.info("Parent logging")
    child_logger.warn("Child logging")

    expect(output.string).to eq([
      "\e[32m#{styles[:info][:symbol]}\e[0m ",
      "\e[32minfo\e[0m    ",
      "Parent logging            ",
      "\e[32mapp\e[0m=parent \e[32menv\e[0m=prod\n",
      "\e[33m#{styles[:warn][:symbol]}\e[0m ",
      "\e[33mwarning\e[0m ",
      "Child [FILTERED]          ",
      "\e[33mapp\e[0m=child \e[33menv\e[0m=prod\n"
    ].join)
  end
end
