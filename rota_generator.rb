
# Generic classes

class Worker
    def initialize(id, name, job, max_hours=40)
      @worker_id = id
      @worker_name = name
      @worker_job = job
      @worker_max_hours = max_hours
    end

    attr_reader :worker_id  
    attr_reader :worker_name  
    attr_reader :worker_job  
    attr_reader :worker_max_hours  
end

class Role

    def initialize(role, encoded_hours)
      @role = role
      @encoded_hours = encoded_hours
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
    def initialize(duration, employee_shifts)
       @duration = duration
       @employee_shifts = employee_shifts
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
        id, name, job, max_hours = line.split(", ")
        worker = Worker.new(id, name, job, max_hours)
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
  for i in role_details.encoded_hours do
    temp = []
    # new list for each other of possible work id's using something like line below
    # order by holiday if possible
    workers.select{|worker| calculate_role_skills(worker.worker_job) == i.role}
    possible_workers.push(temp)
  end
  return possible_workers
end

# Main generate function

def generate_rota(role_hours, workers)
    # First go through the roles and see whats needed when
    for i in role_hours do
        possible_workers = get_possible_workers(i, workers)
        i.assign_possible_workers(possible_workers)
    end

    # Now go through whats needed and assign hours prefering who's not asked for time off
    for i in workers do
    
      puts i
      
    end
end

Workers = []
Role_Hours = []
get_worker_data()
get_role_data()
puts "#{Role_Hours}"
puts "#{Workers}"

generate_rota(Role_Hours, Workers)