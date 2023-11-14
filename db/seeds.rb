# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task["csv_load:all"].invoke
@bulk_discount1 = Merchant.find(1).bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 20)
@bulk_discount2 = Merchant.find(1).bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 30)