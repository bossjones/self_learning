// Package github provides a Go API for the GitHub issue tracker.
// See https://developer.github.com/v3/search/#search-issues.
package github

import "time"

const (
	IssuesURL = "https://api.github.com/search/issues"
	APIURL    = "https://api.github.com/"
)

type IssuesSearchResult struct {
	TotalCount int `json:"total_count"`
	Items      []*Issue
}

type Issue struct {
	Number    int
	HTMLURL   string `json:"html_url"`
	Title     string
	State     string
	User      *User
	CreatedAt time.Time `json:"created_at"`
	Body      string    // in Markdown format
	Score     float64
}

type User struct {
	Login   string
	HTMLURL string `json:"html_url"`
}

type NewIssue struct {
	Title  string
	Body   string
	Labels []string
}