//
//  GithubScope.swift
//  LoveGitHub
//
//  Created by yang on 26/10/2017.
//

public enum GithubScope: String {
    
    /// Grants read/write access to profile info only. Note that this scope includes user:email and user:follow.
    case user
    
    /// Grants read access to a user's email addresses.
    case userEmail = "user:email"
    
    /// Grants access to follow or unfollow other users.
    case userFollow = "user:follow"
    
    /// Grants read/write access to code, commit statuses, collaborators, and deployment statuses for public repositories and organizations. Also required for starring public repositories.
    case publicRepo = "public_repo"
    
    /// Grants read/write access to code, commit statuses, invitations, collaborators, adding team memberships, and deployment statuses for public and private repositories and organizations.
    case repo
    
    /// Grants access to deployment statuses(https://developer.github.com/v3/repos/deployments/) for public and private repositories. This scope is only necessary to grant other users or services access to deployment statuses, without granting access to the code.
    case repoDeployment = "repo_deployment"
    
    /// Grants read/write access to public and private repository commit statuses. This scope is only necessary to grant other users or services access to private repository commit statuses without granting access to the code.
    case repoStatus = "repo:status"
    
    /// Grants accept/decline abilities for invitations to collaborate on a repository. This scope is only necessary to grant other users or services access to invites without granting access to the code.
    case repoInvite = "repo:invite"
    
    /// Grants access to delete adminable repositories.
    case deleteRepo = "delete_repo"
    
    /// Grants read access to a user's notifications. repo also provides this access.
    case notifications
    
    /// Grants write access to gists.
    case gist
    
    /// Grants read and ping access to hooks in public or private repositories.
    case readRepo_hook = "read:repo_hook"
    
    /// Grants read, write, and ping access to hooks in public or private repositories.
    case writeRepo_hook = "write:repo_hook"
    
    ///Grants read, write, ping, and delete access to hooks in public or private repositories.
    case adminRepo_hook = "admin:repo_hook"
    
    /// Grants read, write, ping, and delete access to organization hooks. Note: OAuth tokens will only be able to perform these actions on organization hooks which were created by the OAuth App. Personal access tokens will only be able to perform these actions on organization hooks created by a user.
    case adminOrgHook = "admin:org_hook"
    
    /// Read-only access to organization, teams, and membership.
    case readOrg = "read:org"
    
    /// Publicize and unpublicize organization membership.
    case writeOrg = "write:org"
    
    /// Fully manage organization, teams, and memberships.
    case adminOrg = "admin:org"
    
    /// List and view details for public keys.
    case readPublicKey = "read:public_key"
    
    /// Create, list, and view details for public keys.
    case writePublicKey = "write:public_key"
    
    /// Fully manage public keys.
    case adminPublicKey = "admin:public_key"
    
    /// List and view details for GPG keys.
    case readGpgKey = "read:gpg_key"
    
    /// Create, list, and view details for GPG keys.
    case writeGpgKey = "write:gpg_key"
    
    /// Fully manage GPG keys.
    case adminGpgKey = "admin:gpg_key"
}
