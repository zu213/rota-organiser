
# Generic classes

class Worker
    def initialize(id, name, job, encoded_timeoff, max_hours=40)
      @worker_id = id
      @worker_name = name
      @worker_job = job
      @worker_max_hours = Integer(max_hours)
      @encoded_timeoff = encoded_timeoff.split("").map(&:to_i)
    end

    def reduce_hours(hours)
      @worker_max_hours -= hours
    end

    attr_reader :worker_id  
    attr_reader :worker_name  
    attr_reader :worker_job  
    attr_reader :worker_max_hours
    attr_reader :encoded_timeoff
end

class Role

    def initialize(role, encoded_hours)
      @role = role
      @encoded_hours = encoded_hours.split("").map(&:to_i)
      @possible_workers = nil
    end

    def assign_possible_workers(pos_workers)
      @possible_workers = pos_workers
    end

    attr_reader :role 
    attr_reader :encoded_hours
    attr_reader :possible_workers
end 

class Rota
    def initialize(duration)
       @duration = duration
       @employee_shifts = []
    end

    def add_shift(worker, encoded_time)
      @employee_shifts.push([worker, encoded_time])
    end
end

# This maps roles to the requirments for the role
ROLE_REQUIREMENTS = {
  'Junior' => ['ANY',1],
  'Senior' => ['ANY',2],  
  'Specialist_Cardio' => ['CARD',2],  
}

def calculate_role_requirement(op)
  ROLE_REQUIREMENTS[op] || 0  
end

# This maps roles to what they are able to do
ROLE_SKILLS = {
  'Junior' => [['ANY',1]],
  'Senior' => [['ANY',2]],  
  'Specialist_Cardio' => [['ANY',2], ['CARD', 2]],  
}

def calculate_role_skills(op)
  ROLE_SKILLS[op] || 0  
end

# Functions for accessing files for sample test

def get_worker_data ()  
    file = File.open("sample_workers.csv", "r")
    file.each_line do |line|
        next if line.start_with?("#") || line.strip.empty?

        line.strip!
        id, name, job, max_hours, timeoff = line.split(", ")
        worker = Worker.new(id, name, job, timeoff, max_hours)
        Workers.push(worker)
    end
    file.close
end

def get_role_data ()  
    file = File.open("sample_hours.csv", "r")
    file.each_line do |line|
        next if line.start_with?("#") || line.strip.empty?

        line.strip!
        role, encoded_hours = line.split(", ")
        role_requirements = Role.new(role, encoded_hours)
        Role_Hours.push(role_requirements)
    end
    file.close
end

# helper functions for main generate

def get_possible_workers(role_details, workers)
  role_requirement = calculate_role_requirement(role_details.role)
  possible_workers = []
  # Iterate through strings needs to be fixed
  role_details.encoded_hours.each_with_index do |i, index|
    temp = []
    # new list for each other of possible work id's using something like line below
    temp = workers.select{|worker| calculate_role_skills(worker.worker_job).include?(role_requirement)}
    temp.sort_by {|worker| worker.encoded_timeoff[index]}
    possible_workers.push(temp)
  end
  return possible_workers
end

def fill_shifts(role_details, shift_length=8)
  shifts = Array.new(role_details.encoded_hours.length()) { [] }
  copy = role_details.encoded_hours
  assigned_today = []
  copy.each_with_index do |_, index|
    staff_needed = copy[index]
    
    for worker in role_details.possible_workers[index] do
      if staff_needed < 1
        break
      end
      if worker.worker_max_hours >= shift_length && !assigned_today.include?(worker.worker_id)

        # assign worker to shift
        worker.reduce_hours(shift_length)
        shifts[index..index+shift_length-1].each { |arr| arr.push(worker.worker_id)}
        copy[index..index+shift_length-1] = copy[index..index+shift_length-1].map { |x| x - 1 }
        staff_needed -= 1
        assigned_today.push(worker.worker_id)
      end
    end
  end
  return shifts
end

# Main generate function

def generate_rota(role_hours, workers)
    # First go through the roles and see whats needed when
    for i in role_hours do
        possible_workers = get_possible_workers(i, workers)
        i.assign_possible_workers(possible_workers)
    end

    # Now go through whats needed and assign hours prefering who's not asked for time off as by this, this is done by default.
    role_shifts = []
    for i in role_hours do
      shifts = fill_shifts(i)

      # make them pretty
      shifts = shifts.map do |shift|
        if shift.length < 1
          "( _ )"
        else
          "( " + shift.join(", ") + " )"
        end
      end
      
      temp = {:name => i.role, :shifts => shifts}
      role_shifts.push(temp)
    end

    return role_shifts
end

Workers = []
Role_Hours = []
get_worker_data()
get_role_data()
#puts "#{Role_Hours}"
#puts "#{Workers}"

Final_Shifts = generate_rota(Role_Hours, Workers)
for i in Final_Shifts do
  #puts "#{i}"
  puts "Shifts for " + i[:name] + " are " + i[:shifts].join(', ')
end
