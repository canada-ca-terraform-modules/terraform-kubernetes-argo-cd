package test

import (
	"context"
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	v1 "k8s.io/api/rbac/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// Returns a RoleBinging object with the given name and namespace.
// Will fail the test if the RoleBinding does not exist.
func getRoleBinding(t *testing.T, options *k8s.KubectlOptions, namespace string, roleBindingName string) *v1.RoleBinding {
	clientset, err := k8s.GetKubernetesClientFromOptionsE(t, options)
	if err != nil {
		fmt.Print(err)
		t.Fail()
	}

	roleBinding, err := clientset.RbacV1().
		RoleBindings(namespace).
		Get(context.Background(), roleBindingName, metav1.GetOptions{})
	if err != nil {
		fmt.Print(err)
		t.Fail()
	}

	return roleBinding
}
