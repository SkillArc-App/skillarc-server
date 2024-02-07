turner_employer = Employer.create!(
  id: 'eeaba08a-1ade-4250-b23c-0ae331576d2a',
  name: 'Turner Construction Company',
  bio: 'Turner is a North America-based, international construction services company and is a leading builder in diverse and numerous market segments. The company has earned recognition for undertaking large, complex projects, fostering',
  location: 'Global',
  logo_url:
    'https://media.licdn.com/dms/image/C4E0BAQGLeh2i2nqj-A/company-logo_200_200/0/1528380278542?e=2147483647&v=beta&t=L9tuLliGKhuA4_WGgrM1frOOSuxR6aupcExGE-r45g0'
)

sg_employer = Employer.create!(
  id: 'c844012e-751b-4d0a-af62-89339a3f8af4',
  name: 'The Superior Group',
  bio: 'The Superior Group is a ​national leader in electrical construction, engineering, and technology services.',
  location: 'Ohio',
  logo_url:
    'https://media.licdn.com/dms/image/C4E0BAQGLeh2i2nqj-A/company-logo_200_200/0/1528380278542?e=2147483647&v=beta&t=L9tuLliGKhuA4_WGgrM1frOOSuxR6aupcExGE-r45g0'
)

recruiter_user = User.create!(
  id: SecureRandom.uuid,
  first_name: 'Recruiter',
  last_name: 'User',
  email: 'recruiter@blocktrianapp.com',
  sub: 'recruitersub'
)

Recruiter.create!(
  id: SecureRandom.uuid,
  employer: turner_employer,
  user: recruiter_user
)

mechanic_job = Job.create!(
  id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
  employer: turner_employer,
  benefits_description: 'Dental insurance Vision insurance Disability insurance 401(k)',
  responsibilities_description:
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  employment_title: 'Level 2 Mechanic',
  location: 'Columbus, OH',
  employment_type: 'FULLTIME',
  hide_job: false,
  industry: ['manufacturing', 'construction'],
  schedule: '40-55 hours weekly',
  work_days: 'Weekdays',
  requirements_description:
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
)

earthwork_job = Job.create!(
  id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
  employer: sg_employer,
  benefits_description: 'Dental insurance Vision insurance Disability insurance 401(k)',
  responsibilities_description:
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  employment_title: 'Earthwork Journeyman',
  industry: ['construction'],
  location: 'Dublin, OH',
  employment_type: 'FULLTIME',
  hide_job: false,
  schedule: '40 hours weekly',
  work_days: 'Weekdays, flexible',
  requirements_description:
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
)

contractor = Job.create!(
  id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
  employer: sg_employer,
  benefits_description: 'Dental insurance, Vision insurance, Disability insurance 401(k)',
  responsibilities_description:
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  employment_title: 'General Contractor',
  industry: ['healthcare', 'construction'],
  location: 'New Albany, OH',
  employment_type: 'FULLTIME',
  hide_job: false,
  schedule: '40-50 hours, weekly',
  work_days: 'Weekdays, some weekends',
  requirements_description:
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
)

tag = Tag.create!(
  id: SecureRandom.uuid,
  name: 'No experience needed'
)

Tag.create!([
              {
                id: SecureRandom.uuid,
                name: 'No experience needed'
              },
              {
                id: SecureRandom.uuid,
                name: 'Part time only'
              },
              {
                id: SecureRandom.uuid,
                name: 'Transportation assistance'
              },
              {
                id: SecureRandom.uuid,
                name: 'ESL-Friendly'
              },
              {
                id: SecureRandom.uuid,
                name: 'Fair chance employer'
              }
            ])

JobTag.create!(
  id: SecureRandom.uuid,
  job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
  tag_id: tag.id
)

CareerPath.create!(
  [
    {
      id: SecureRandom.uuid,
      job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
      title: 'Level 1',
      upper_limit: '60000',
      lower_limit: '55000',
      order: 0
    },
    {
      id: SecureRandom.uuid,
      job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
      title: 'Level 2',
      upper_limit: '65000',
      lower_limit: '60000',
      order: 1
    },
    {
      id: SecureRandom.uuid,
      job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
      title: 'Level 3',
      upper_limit: '70000',
      lower_limit: '65000',
      order: 2
    },
    {
      id: SecureRandom.uuid,
      job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
      title: 'Apprentice',
      upper_limit: '50',
      lower_limit: '45',
      order: 0
    },
    {
      id: SecureRandom.uuid,
      job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
      title: 'Journeyman',
      upper_limit: '60',
      lower_limit: '50',
      order: 1
    },
    {
      id: SecureRandom.uuid,
      job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
      title: 'Super',
      upper_limit: '80',
      lower_limit: '60',
      order: 2
    },
    {
      id: SecureRandom.uuid,
      job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
      title: 'Entry Level',
      upper_limit: '65000',
      lower_limit: '60000',
      order: 0
    },
    {
      id: SecureRandom.uuid,
      job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
      title: 'Mid-Level',
      upper_limit: '75000',
      lower_limit: '70000',
      order: 1
    }
  ]
)

JobPhoto.create!(
  [{
    id: SecureRandom.uuid,
    job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
    photo_url:
      'https://images.unsplash.com/photo-1517524206127-48bbd363f3d7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWVjaGFuaWN8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=60'
  },
   {
     id: SecureRandom.uuid,
     job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
     photo_url:
       'https://images.unsplash.com/photo-1632733711679-529326f6db12?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fG1lY2hhbmljfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60'
   },
   {
     id: SecureRandom.uuid,
     job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
     photo_url:
       'https://images.unsplash.com/photo-1599474151975-1f978922fa02?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fG1lY2hhbmljfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60'
   },
   {
     id: SecureRandom.uuid,
     job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
     photo_url:
       'https://plus.unsplash.com/premium_photo-1661899566960-942b158bab49?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZWFydGh3b3JrfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60'
   },
   {
     id: SecureRandom.uuid,
     job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
     photo_url:
       'https://images.unsplash.com/photo-1675600653433-c9f0040f62b0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGVhcnRod29ya3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60'
   },
   {
     id: SecureRandom.uuid,
     job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
     photo_url:
       'https://images.unsplash.com/photo-1612878100556-032bbf1b3bab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGVhcnRod29ya3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60'
   },
   {
     id: SecureRandom.uuid,
     job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
     photo_url:
       'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y29uc3RydWN0aW9uJTIwd29ya2VyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60'
   },
   {
     id: SecureRandom.uuid,
     job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
     photo_url:
       'https://plus.unsplash.com/premium_photo-1664299941780-e8badc0b1617?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y29uc3RydWN0aW9uJTIwd29ya2VyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60'
   }]
)

Testimonial.create!([
                      {
                        id: SecureRandom.uuid,
                        job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
                        name: 'Jane Doe',
                        testimonial:
                          'Ive worked here for 7 years and love it! This company is like a second family',
                        title: 'Project Manager',
                        photo_url:
                          'https://plus.unsplash.com/premium_photo-1665865607224-9dcd2f488b38?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHdvbWFufGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60'
                      },
                      {
                        id: SecureRandom.uuid,
                        job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
                        name: 'Jack Wilson',
                        testimonial: 'TSG is a great company. Fair pay, and great benefits!',
                        title: 'Plumber',
                        photo_url:
                          'https://plus.unsplash.com/premium_photo-1682724031797-710f0ac9193f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y29uc3RydWN0aW9uJTIwd29ya2VyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60'
                      },
                      {
                        id: SecureRandom.uuid,
                        job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
                        name: 'Lauren Jackson',
                        testimonial: 'I love my job.',
                        title: 'Project Accountant'
                      },
                      {
                        id: SecureRandom.uuid,
                        job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
                        name: 'John Doe',
                        testimonial: 'This is a great place to work!',
                        title: 'Project Manager'
                      },
                    ])

MasterCertification.create!([
                              {
                                id: 'a7ce3140-6b1a-4804-8071-364e7c80c44a',
                                certification: "Driver's License"
                              },
                              {
                                id: 'bf8ff563-3df5-47a7-9e19-3a374b15e8a8',
                                certification: 'High School Diploma'
                              },
                              {
                                id: '44a6b1a5-8cef-4eeb-b6c5-a0b762fca5ea',
                                certification: 'GED'
                              },
                              {
                                id: 'c67bec6a-31e9-4cbe-893d-804ac281a4eb',
                                certification: 'Fire Alarm License'
                              },
                              {
                                id: '93cc2a36-1c3a-42d6-8ffb-b1a2edce9238',
                                certification: 'OSHA 10'
                              },
                              {
                                id: '59e97302-5339-4443-a811-21d1ce09d0aa',
                                certification: 'OSHA 30'
                              },
                              {
                                id: 'cd122e26-f1af-4a1c-91fd-371e60ed73fa',
                                certification: 'Forklift Certified'
                              },
                              {
                                id: '3dd6ac83-8d19-4460-82bb-db9794b3d5d3',
                                certification: 'CDL A'
                              },
                              {
                                id: '0f34f1e7-7937-43af-941a-a4e12e9c46c4',
                                certification: 'CDL B'
                              },
                              {
                                id: '9ea915c1-54be-4817-9703-f3f22f3f09a7',
                                certification: 'Customer Service'
                              },
                              {
                                id: 'baa510a2-f96b-4f41-9164-90eaceca0c90',
                                certification: 'Journeyman'
                              },
                              {
                                id: 'c6332c74-bcfb-40fc-a823-e81fac6cd3d6',
                                certification: 'Crane Operation'
                              },
                              {
                                id: '422c829b-89d2-46a8-b120-d3dc5d0e6f08',
                                certification: 'Certified Construction Manager (CCM)'
                              },
                              {
                                id: 'c1be79ab-6908-4614-a486-f7ffe788f269',
                                certification: 'Certified Safety Manger'
                              },
                              {
                                id: '90a3c873-e9b4-47ae-a05d-440eb98326d6',
                                certification: 'Certified Phlebotomy Technician (CPT)'
                              },
                              {
                                id: 'b6dd096c-078d-43d4-bed7-94826e2b859c',
                                certification: 'Certified Patient Care Technician (CPCT)'
                              },
                              {
                                id: '0b27db4a-8687-4cd2-ab14-38367aa97830',
                                certification: 'Certified Medical Assistant (CMA)'
                              },
                              {
                                id: 'd533c908-e4a4-4fe8-a598-9a5ae3083c99',
                                certification: 'Certified Nursing Assistant (CNA)'
                              },
                              {
                                id: 'e1680acf-10ed-4456-85d8-3bb2f2f449f4',
                                certification: 'Home Health Aid'
                              },
                              {
                                id: '17ed7a82-749a-4527-b573-dfd11a59cec8',
                                certification: 'Emergency Medical Technician (EMT)'
                              },
                              {
                                id: '9368b029-4c64-4217-bbe4-34e0978da839',
                                certification: 'Healthcare Compliance Certification'
                              },
                              {
                                id: '09448e8b-5aba-4692-8339-4dddabbc564e',
                                certification: 'Medical Biller and Coder Certification'
                              },
                              {
                                id: '103fdb43-23d9-4f0a-9ec7-f2296f7662e5',
                                certification: 'Certified Pharmacy Technician'
                              },
                            ])

MasterSkill.create!([
                      {
                        id: '3703d7d0-e20a-4635-a9d9-2092c7b03000',
                        skill: 'Adaptability',
                        type: 'PERSONAL'
                      },
                      {
                        id: 'c4ca3bc7-b7e7-4193-ac90-532e0179a474',
                        skill: 'Communication',
                        type: 'PERSONAL'
                      },
                      {
                        id: 'e0627968-c5f8-4f2c-9b23-948d2374644f',
                        skill: 'Creativity',
                        type: 'PERSONAL'
                      },
                      {
                        id: 'c0f0442f-e01f-4aab-82c8-91e41cee2bbd',
                        skill: 'Dependability',
                        type: 'PERSONAL'
                      },
                      {
                        id: 'ef0b7921-171d-4157-93bf-bf309f73ad57',
                        skill: 'Interpersonal Skills',
                        type: 'PERSONAL'
                      },
                      {
                        id: '64543e56-dcc4-46f6-adec-b2a166149d3c',
                        skill: 'Leadership',
                        type: 'PERSONAL'
                      },
                      {
                        id: 'f7b9b9a5-43a4-488d-a600-01a3018c2e1e',
                        skill: 'Professionalism',
                        type: 'PERSONAL'
                      },
                      {
                        id: '5a12a33d-058b-4ba0-91c3-0725bade34ae',
                        skill: 'Self Awareness',
                        type: 'PERSONAL'
                      },
                      {
                        id: 'a1f51ba9-3988-4e74-8fea-71bb1357a312',
                        skill: 'Teamwork',
                        type: 'PERSONAL'
                      },
                      {
                        id: '8a39653c-530b-4abe-a12e-56c981544caa',
                        skill: 'Willingness to Learn',
                        type: 'PERSONAL'
                      },
                      {
                        id: '58b90c17-fead-4af9-a8db-3ac152b0ad7e',
                        skill: 'Other',
                        type: 'PERSONAL'
                      },
                      {
                        id: 'c1698e1e-c5ec-4f9d-8007-cb5a3f1b1968',
                        skill: 'Math Basics',
                        type: 'TECHNICAL'
                      },
                      {
                        id: '7d76ec3e-2727-403b-9f0c-6fb75e31ebb7',
                        skill: 'Physically able',
                        type: 'TECHNICAL'
                      },
                      {
                        id: '2b5d40f4-ec34-4eb8-9732-2264e9c88184',
                        skill: 'Digital Technology Basics',
                        type: 'TECHNICAL'
                      },
                      {
                        id: '7ec2826d-8d1a-4433-9c94-ff194ceec7f9',
                        skill: 'Customer Service',
                        type: 'TECHNICAL'
                      },
                      {
                        id: 'f3bc0510-6ad8-4159-aa63-f9504572fd5c',
                        skill: 'Marketing/Sales',
                        type: 'TECHNICAL'
                      },
                      {
                        id: 'f33952cb-1f5b-4633-8697-095bd7a7d0ce',
                        skill: 'Accounting/Budgeting',
                        type: 'TECHNICAL'
                      },
                      {
                        id: 'ec27be9b-53df-4fc1-808b-850fc7b723b0',
                        skill: 'Blueprint Reading',
                        type: 'TECHNICAL'
                      },
                      {
                        id: '21a392df-5f88-4da4-a489-d1ef221b0771',
                        skill: 'Computer Basics',
                        type: 'TECHNICAL'
                      },
                      {
                        id: 'ebb772a4-e7e9-4bac-9110-95e895b5dfe7',
                        skill: 'Conflict Management',
                        type: 'TECHNICAL'
                      },
                      {
                        id: 'a294d91b-189a-4c9d-a88f-46addb1350f4',
                        skill: 'Mechanical Aptitude',
                        type: 'TECHNICAL'
                      },
                      {
                        id: '0148f08f-f9ca-41e9-ad06-22665714bdaf',
                        skill: 'Negotiation',
                        type: 'TECHNICAL'
                      },
                      {
                        id: '731e5aa5-e8d4-4a4e-9acb-3de414a17773',
                        skill: 'Reading & Writing',
                        type: 'TECHNICAL'
                      },
                      {
                        id: 'c3dd6dbf-b974-4590-b5f8-3e316ea4e81e',
                        skill: 'Time Management',
                        type: 'TECHNICAL'
                      },
                      {
                        id: '674464b5-66cc-423b-9297-7acdbab980c7',
                        skill: 'Web Development',
                        type: 'TECHNICAL'
                      },
                      {
                        id: '5f3adf92-5bdc-4f2e-9e1b-8792cf0f6ff9',
                        skill: 'Other',
                        type: 'TECHNICAL'
                      },
                    ])

DesiredSkill.create!([
                       {
                         id: SecureRandom.uuid,
                         job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
                         master_skill_id: '3703d7d0-e20a-4635-a9d9-2092c7b03000'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
                         master_skill_id: 'e0627968-c5f8-4f2c-9b23-948d2374644f'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
                         master_skill_id: 'f33952cb-1f5b-4633-8697-095bd7a7d0ce'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
                         master_skill_id: '0148f08f-f9ca-41e9-ad06-22665714bdaf'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
                         master_skill_id: '731e5aa5-e8d4-4a4e-9acb-3de414a17773'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
                         master_skill_id: 'c4ca3bc7-b7e7-4193-ac90-532e0179a474'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
                         master_skill_id: 'f7b9b9a5-43a4-488d-a600-01a3018c2e1e'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
                         master_skill_id: 'c3dd6dbf-b974-4590-b5f8-3e316ea4e81e'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
                         master_skill_id: 'ebb772a4-e7e9-4bac-9110-95e895b5dfe7'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
                         master_skill_id: '3703d7d0-e20a-4635-a9d9-2092c7b03000'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
                         master_skill_id: 'a1f51ba9-3988-4e74-8fea-71bb1357a312'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
                         master_skill_id: '7d76ec3e-2727-403b-9f0c-6fb75e31ebb7'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
                         master_skill_id: 'c3dd6dbf-b974-4590-b5f8-3e316ea4e81e'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
                         master_skill_id: '7d76ec3e-2727-403b-9f0c-6fb75e31ebb7'
                       },
                     ])

LearnedSkill.create!([
                       {
                         id: SecureRandom.uuid,
                         job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
                         master_skill_id: 'ef0b7921-171d-4157-93bf-bf309f73ad57'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '08cedbc3-2e7b-4ba0-b7af-03df98c187b3',
                         master_skill_id: 'ec27be9b-53df-4fc1-808b-850fc7b723b0'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
                         master_skill_id: '3703d7d0-e20a-4635-a9d9-2092c7b03000'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
                         master_skill_id: '5a12a33d-058b-4ba0-91c3-0725bade34ae'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: 'c2c2d40d-4028-409e-8145-e77384a44daf',
                         master_skill_id: 'f33952cb-1f5b-4633-8697-095bd7a7d0ce'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
                         master_skill_id: '3703d7d0-e20a-4635-a9d9-2092c7b03000'
                       },
                       {
                         id: SecureRandom.uuid,
                         job_id: '25ecbccf-9043-4da8-91b1-a5eee5c63634',
                         master_skill_id: '731e5aa5-e8d4-4a4e-9acb-3de414a17773'
                       },
                     ])

trained_seeker_with_reference = Profile.create!(
  id: SecureRandom.uuid,
  bio: "I learn stuff",
  status: "I'm a high school student.",
  user: User.new(
    id: SecureRandom.uuid,
    first_name: 'Tom',
    last_name: 'Hanks',
    email: 'trained-seeker-with-reference@blocktrainapp.com',
    sub: 'tomsub'
  )
)

Seeker.create!(**trained_seeker_with_reference.attributes.to_h.except("status", "met_career_coach"))

trained_seeker = Profile.create!(
  id: SecureRandom.uuid,
  bio: 'I learn stuff',
  status: "I'm a high school student.",
  user: User.new(
    id: 'cll2k67ub0000ao24lvmbzcqs',
    first_name: 'Tim',
    last_name: 'Allen',
    email: 'trained-seeker@blocktrainapp.com',
    sub: 'timsub'
  )
)

Seeker.create!(**trained_seeker.attributes.to_h.except("status", "met_career_coach"))

seeker_with_profile = Profile.create!(
  id: SecureRandom.uuid,
  bio: 'I learn stuff',
  status: "I'm an adult with some work experience. Looking to switch to trades.",
  user: User.new(
    id: 'cll0yrt890002aor2v4pwo4ia',
    first_name: 'Rita',
    last_name: 'Wilson',
    email: 'seeker-with-profile@blocktrainapp.com',
    sub: 'ritasub'
  )
)

Seeker.create!(**seeker_with_profile.attributes.to_h.except("status", "met_career_coach"))

Applicant.create!(
  id: SecureRandom.uuid,
  profile: seeker_with_profile,
  seeker: FactoryBot.create(:seeker),
  job: mechanic_job,
  applicant_statuses: [
    ApplicantStatus.new(
      id: SecureRandom.uuid,
      status: 'new'
    )
  ]
)

OnboardingSession.create!(
  id: SecureRandom.uuid,
  user_id: seeker_with_profile.user.id,
  started_at: seeker_with_profile.created_at,
  completed_at: seeker_with_profile.created_at + 1.day
)

megans_recruits = TrainingProvider.create!(
  id: SecureRandom.uuid,
  name: "Megan's Recruits",
  description: "We train people to help them get jobs"
)

cul = TrainingProvider.create!(
  id: SecureRandom.uuid,
  name: 'Columbus Urban League',
  description:
    'We are super good at doing the thing we do which is to help the people we work with get jobs'
)

trainer = User.create!(
  id: SecureRandom.uuid,
  first_name: 'Meghan',
  last_name: 'Trainer',
  email: 'trainer@blocktrainapp.com',
  user_type: 'TRAINING_PROVIDER',
  sub: 'megsub'
)

TrainingProviderProfile.create!(
  id: SecureRandom.uuid,
  training_provider_id: cul.id,
  user_id: trainer.id
)

trainer_with_reference = User.create!(
  id: SecureRandom.uuid,
  first_name: 'Bill',
  last_name: 'Traynor',
  email: 'trainer-with-reference@blocktrainapp.com',
  user_type: 'TRAINING_PROVIDER',
  sub: 'billsub'
)

admin_user = User.create!(
  id: SecureRandom.uuid,
  first_name: 'Jake',
  last_name: 'Not-Onboard',
  email: 'admind@blocktrainapp.com',
  sub: 'jakesub'
)

admin = Role.create!(id: SecureRandom.uuid, name: "admin")

UserRole.create!(
  id: SecureRandom.uuid,
  role_id: admin.id,
  user_id: admin_user.id
)

bill_trainer_profile = TrainingProviderProfile.create!(
  id: SecureRandom.uuid,
  training_provider_id: megans_recruits.id,
  user_id: trainer_with_reference.id
)

cool_program = Program.create!(
  id: SecureRandom.uuid,
  name: 'Cool Program',
  description: 'You learn stuff',
  training_provider_id: megans_recruits.id
)

welding = Program.create!(
  id: SecureRandom.uuid,
  name: 'Welding Class 2023 Q1',
  description: 'You weld stuff',
  training_provider_id: cul.id
)

plumbing = Program.create!(
  id: SecureRandom.uuid,
  name: 'Plumbing Class 2023 Q1',
  description: 'You plumb stuff',
  training_provider_id: cul.id
)

carpentry = Program.create!(
  id: SecureRandom.uuid,
  name: 'Carpentry Class 2023 Q1',
  description: 'You carp stuff',
  training_provider_id: cul.id
)

ProgramSkill.create!([
                       {
                         id: SecureRandom.uuid,
                         program_id: carpentry.id,
                         skill_id: 'c0f0442f-e01f-4aab-82c8-91e41cee2bbd'
                       },
                       {
                         id: SecureRandom.uuid,
                         program_id: carpentry.id,
                         skill_id: 'ec27be9b-53df-4fc1-808b-850fc7b723b0'
                       }
                     ])

SeekerTrainingProvider.create!(
  id: SecureRandom.uuid,
  user_id: trained_seeker_with_reference.user_id,
  program_id: cool_program.id,
  training_provider_id: megans_recruits.id
)

SeekerTrainingProvider.create!(
  id: SecureRandom.uuid,
  user_id: trained_seeker.user.id,
  program_id: plumbing.id,
  training_provider_id: cul.id
)

SeekerTrainingProvider.create!(
  id: SecureRandom.uuid,
  user_id: trained_seeker.user.id,
  program_id: welding.id,
  training_provider_id: cul.id
)

SeekerTrainingProvider.create!(
  id: SecureRandom.uuid,
  user_id: trained_seeker_with_reference.user_id,
  program_id: carpentry.id,
  training_provider_id: cul.id
)

Reference.create!(
  id: SecureRandom.uuid,
  training_provider_id: cul.id,
  seeker_profile_id: trained_seeker_with_reference.id,
  author_profile_id: bill_trainer_profile.id,
  seeker: FactoryBot.create(:seeker),
  reference_text: 'This person is good at carpentry'
)

coach_user = User.create!(
  id: SecureRandom.uuid,
  first_name: 'Coach',
  last_name: 'User',
  email: 'coach@blocktrainapp.com',
  sub: 'coachsub'
)

coach = Role.create!(id: SecureRandom.uuid, name: Role::Types::COACH)

UserRole.create!(
  id: SecureRandom.uuid,
  role_id: coach.id,
  user_id: coach_user.id
)

coach = Coaches::Coach.create!(
  coach_id: SecureRandom.uuid,
  user_id: coach_user.id,
  email: coach_user.email
)

coach_seeker_context = Coaches::CoachSeekerContext.create!(
  profile_id: seeker_with_profile.id,
  user_id: seeker_with_profile.user.id,
  first_name: seeker_with_profile.user.first_name,
  last_name: seeker_with_profile.user.last_name,
  email: seeker_with_profile.user.email,
  phone_number: seeker_with_profile.user.phone_number,
  stage: 'profile_created',
  assigned_coach: coach.id
)

Coaches::SeekerApplication.create!(
  employer_name: mechanic_job.employer.name,
  employment_title: mechanic_job.employment_title,
  application_id: SecureRandom.uuid,
  status: "pending intro",
  job_id: mechanic_job.id,
  coach_seeker_context:
)

Coaches::SeekerApplication.create!(
  employer_name: earthwork_job.employer.name,
  employment_title: earthwork_job.employment_title,
  application_id: SecureRandom.uuid,
  status: "pass",
  job_id: earthwork_job.id,
  coach_seeker_context:
)

Reason.create!(description: "This candidate does not meet the role requirements")
Reason.create!(description: "The role is filled, no longer accepting applications")
Reason.create!(description: "The role is seasonal or pausing accepting candidates")
Reason.create!(description: "This candidate is a better for another role")
Reason.create!(description: "The candidate did not show up for the interview")

FactoryBot.create(:barrier, name: "Background")
FactoryBot.create(:barrier, name: "Unable to Drive")

FactoryBot.create(:coaches__job, job_id: contractor.id, employment_title: contractor.employment_title)
