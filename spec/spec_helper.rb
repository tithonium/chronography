def long_day_should_eq(nth, val)
  expect(described_class.long_week_day(nth)).to eq val
end

def long_month_should_eq(nth, val)
  expect(described_class.long_month(nth)).to eq val
end

RSpec::Expectations.configuration.on_potential_false_positives = :nothing
