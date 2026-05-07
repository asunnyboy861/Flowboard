require 'xcodeproj'

project_path = '/Volumes/ORICO-APFS/app/20260504/Flowboard/Flowboard/Flowboard.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.find { |t| t.name == 'Flowboard' }
source_build_phase = target.source_build_phase

existing_files = source_build_phase.files.map { |f| f.display_name }
puts "Existing files: #{existing_files.inspect}"

base_dir = '/Volumes/ORICO-APFS/app/20260504/Flowboard/Flowboard/Flowboard'

swift_files = [
  'App/MainTabView.swift',
  'Core/Persistence/PersistenceController.swift',
  'Core/Repositories/BoardRepository.swift',
  'Core/Repositories/CardRepository.swift',
  'Core/Repositories/ColumnRepository.swift',
  'Core/Services/SubscriptionManager.swift',
  'Core/Services/NaturalLanguageParser.swift',
  'Core/Services/NotificationService.swift',
  'Core/Models/Board+Extensions.swift',
  'Core/Models/Card+Extensions.swift',
  'Core/Models/Column+Extensions.swift',
  'Core/Models/Tag+Extensions.swift',
  'Features/BoardList/BoardListView.swift',
  'Features/Board/BoardView.swift',
  'Features/Board/ColumnView.swift',
  'Features/Board/CardRowView.swift',
  'Features/Card/CardDetailView.swift',
  'Features/Calendar/CalendarView.swift',
  'Features/Today/TodayView.swift',
  'Features/Settings/SettingsView.swift',
  'Features/Settings/ContactSupportView.swift',
  'Features/Paywall/PaywallView.swift',
  'Features/Onboarding/OnboardingView.swift',
  'Components/PriorityBadge.swift',
  'Components/ProgressBar.swift',
  'Components/TagChip.swift',
  'Extensions/Color+Flowboard.swift',
  'Extensions/Date+Extensions.swift'
]

main_group = project.main_group.find_subpath('Flowboard', true)

swift_files.each do |file|
  next if existing_files.include?(File.basename(file))

  file_path = File.join(base_dir, file)
  next unless File.exist?(file_path)

  dir_parts = File.dirname(file).split('/')
  current_group = main_group

  dir_parts.each do |part|
    next if part == '.'
    sub = current_group.children.find { |c| c.display_name == part }
    if sub.nil?
      sub = current_group.new_group(part, part)
    end
    current_group = sub
  end

  file_ref = current_group.new_file(File.basename(file))
  source_build_phase.add_file_reference(file_ref)

  puts "Added: #{file}"
end

# Add CoreData model
core_group = main_group.children.find { |c| c.display_name == 'Core' } || main_group.new_group('Core', 'Core')
persistence_group = core_group.children.find { |c| c.display_name == 'Persistence' } || core_group.new_group('Persistence', 'Persistence')

existing_model = persistence_group.children.find { |c| c.display_name == 'Flowboard.xcdatamodeld' }
if existing_model.nil?
  model_ref = persistence_group.new_group('Flowboard.xcdatamodeld', 'Core/Persistence/Flowboard.xcdatamodeld')
  model_ref.last_known_file_type = 'wrapper.xcdatamodel'
  model_ref.source_tree = '<group>'
  build_file = source_build_phase.add_file_reference(model_ref)
  puts "Added: Flowboard.xcdatamodeld"
end

project.save
puts "Project saved successfully!"
