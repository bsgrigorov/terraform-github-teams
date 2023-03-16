locals {
  users = yamldecode(file("${path.module}/teams/users.yaml"))
  teams = yamldecode(file("${path.module}/teams/teams.yaml"))
}

resource "github_membership" "org_members" {
  for_each = local.users
  username = each.value.github_username
  role     = "member"
}

# Add a team to the organization
resource "github_team" "team" {
  for_each    = local.teams
  name        = each.key
  description = each.value.description
  privacy     = "closed"
}

locals {
  # Create temp object that has members and maintainers
  team_members_temp = [
    for team, team_data in local.teams : {
      name        = team
      members     = try(team_data.members, [])
      maintainers = try(team_data.maintainers, [])
    }
  ]

  # Create object for each team-user relationship
  team_members_expanded = flatten([
    for team in local.team_members_temp : concat(
      [
        for member in team.members : {
          name      = "${team.name}-${member}"
          team_name = team.name
          username  = local.users[member].github_username
          role      = "member"
        }
      ],
      [
        for maintainer in team.maintainers : {
          name      = "${team.name}-${maintainer}"
          team_name = team.name
          username  = local.users[maintainer].github_username
          role      = "maintainer"
        }
    ])
  ])
  memberships_count = length(local.team_members_expanded)

  # Create user-team relationship with team id as a key
  team_memberships = flatten([
    for membership in local.team_members_expanded : [
      for tn, t in github_team.team : {
        name     = t.name
        team_id  = t.id
        slug     = t.slug
        username = membership.username
        role     = membership.role
      } if t.slug == membership.team_name
    ]
  ])
}

resource "github_team_membership" "team_members" {
  count = local.memberships_count

  team_id  = local.team_memberships[count.index].team_id
  username = local.team_memberships[count.index].username
  role     = local.team_memberships[count.index].role
}
