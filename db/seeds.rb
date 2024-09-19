# frozen_string_literal: true

organization = Organization.first_or_create! name: '5Aliens'
project = Project.first_or_create! name: 'Hero', organization:
