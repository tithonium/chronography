# coding: utf-8

require 'chronography'
require 'spec_helper'
require 'awesome_print'
AwesomePrint.defaults = {
  index: false,
}

describe Chronography do
end

module Chronography

  shared_examples :calendar do
    it "properly enumerates calendar constants" do
      expect(described_class.day_seconds).to be_a Integer
      expect(described_class.num_week_days).to be_a Integer
      expect(described_class.num_months).to be_a Integer
      expect {
        described_class.num_day_seconds
      }.to raise_error
    end
    # it "defines proper calendar methods" do
    #   expect(described_class.instance_methods.sort).to include(:year, :month, :day)
    #   expect(described_class.instance_methods.sort).to include(:year=, :month=, :day=)
    # end
  end

  shared_examples :clock do
    it "properly enumerates clock constants" do
      expect(described_class.hour_length).to be_a Integer
      expect(described_class.minute_length).to be_a Integer
      expect {
        described_class.second_length
      }.to raise_error
    end
    # it "defines proper clock methods" do
    #   expect(described_class.instance_methods.sort).to include(:hour, :minute, :second)
    #   expect(described_class.instance_methods.sort).to include(:hour=, :minute=, :second=)
    # end
  end

  shared_examples :epoch do
  end

  shared_examples :chronography do
    include_examples :calendar
    include_examples :clock
    include_examples :epoch
  end

  shared_examples :terran do
    include_examples :chronography
    it "acts like a terran chronography" do
      expect(described_class.day_seconds).to eq(86400)
      expect(described_class.rotation_seconds).to be_within(400).of(86400)
      expect(described_class.revolution_seconds).to be_within(43200).of(365.5*86400)
    end
  end

  shared_examples :martian do
    include_examples :chronography
    it "acts like a martian chronography" do
      expect(described_class.day_seconds).to eq(88775)
      expect(described_class.rotation_seconds).to be_within(1).of(88775)
      expect(described_class.revolution_seconds).to be_within(2377).of(687*86400)
    end
  end

  describe Gregorian do
    include_examples :terran
    it "produces appropriate output" do
      expect(described_class.num_week_days).to eq 7
      expect(described_class.num_months).to eq 12
      long_day_should_eq(0, 'Sunday')
      long_day_should_eq(6, 'Saturday')
      long_day_should_eq(7, 'Sunday')
      long_month_should_eq(1, 'January')
      long_month_should_eq(12, 'December')
      long_month_should_eq(13, 'January')
    end
  end

  describe Darian do
    include_examples :martian
    it "produces appropriate output" do
      expect(described_class.num_week_days).to eq 7
      expect(described_class.num_months).to eq 24
      long_day_should_eq(0, 'Solis')
      long_day_should_eq(6, 'Saturni')
      long_day_should_eq(7, 'Solis')
      long_month_should_eq(1, 'Sagittarius')
      long_month_should_eq(24, 'Vrishika')
      long_month_should_eq(25, 'Sagittarius')
    end
  end

  describe Aresian do
    include_examples :martian
    it "produces appropriate output" do
      # expect(described_class.num_week_days).to eq 7
      # expect(described_class.num_months).to eq 24
      # long_day_should_eq(0, 'Soldaie')
      # long_day_should_eq(6, 'Borrsdaie')
      # long_day_should_eq(7, 'Soldaie')
      #
      # long_month_should_eq(1, 'Sagittarius')
      # long_month_should_eq(24, 'Vrishika')
      # long_month_should_eq(25, 'Sagittarius')
    end
    # it "supports timeslip" do
    #   ex = described_class.new(214, 22, 18, 19, 56, 05)
    #   expect(ex.seconds_of_day).to eq(71765)
    #   ex = described_class.new(1, 1, 1, 19, 56, 05)
    #   expect(ex.seconds_of_day).to eq(71765)
    # end
    it "does space math" do
      {
        # 'Telescopic Epoch--' => -11385895164 - 88775,
        # 'Telescopic Epoch'   => -11385895164,
        # 'Known Midnight (Earth)'     => Chronography::Epoch::KNOWN_MIDNIGHT_UE,
        'Known Midnight (Mars)'     => Chronography::Mars::EPOCH,
        'Known Midnight (Mars) + 1 Myear'     => Chronography::Mars::EPOCH + Chronography::Mars::COMMON_YEAR_LENGTH * Chronography::Mars::DAY_SECONDS,
        # 'Spirit Landing'     => 1073137591,
        # 'Unix Epoch'         => Chronography::Epoch::UNIX_UE,
  #      'Marty'              => 225948360,
  #      'Now'                => Time.now
      }.each do |name, tt|
        puts
        puts name
        puts "tt = #{tt.inspect} (#{tt.to_f.inspect})"
        puts "tt.utc = #{tt.utc}" if tt.respond_to?(:utc)
        t = Chronography::Aresian.new(tt)
        puts " t = #{t.inspect}"
        puts " JDᵁᵀ = #{t.JDᵁᵀ.inspect}"
        puts " TT - UTC = Epoch.tai_utc(#{t.to_time.to_f.inspect})+TT_TAI = #{(Epoch.tai_utc(t.to_time)+Epoch::TT_TAI).inspect}"
        puts " JDᵀᵀ = #{t.JDᵀᵀ.inspect}"
        puts "⍙tʲ²⁰⁰⁰ = #{t.⍙tʲ²⁰⁰⁰.inspect}"
        ap t.space
        puts
      end
    end
  end
end
