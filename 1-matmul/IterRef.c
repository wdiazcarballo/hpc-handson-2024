#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <omp.h>
extern void dgemv_(char* trans, int* m, int* n, double* alpha, double* A, int* ldA, double* x, int* incx, double* beta, double* y, int* incy);
extern void dcopy_(int* n, double* x, int* incx, double* y, int* incy);
extern double dnrm2_(int* n, double* x, int* incx);
extern void dgesv_(int* N, int* NRHS, double* A, int* LDA, int* IPIV, double* B, int* LDB, int* info);
extern void sgesv_(int* N, int* NRHS, float* A, int* LDA, int* IPIV, float* B, int* LDB, int* info);
extern void sgetrs_(char* TRANS, int* N, int* NRHS, float* A, int* LDA, int* IPIV, float* B, int* LDB, int* INFO);

void Gen_Problem(int n, double* A, double* b, double* w);
void mydsgesv(int n, double* A, double* b, double* x, int* IPIV, int iter);
double cheak_resi(int n, double* A, double* b, double* x);
void IterRef(int n, double* A, float* LU, double* b, double* x, int* IPIV, int iter);

int main(int argc, char* argv[]) {
	double* A, *T, * b, * x, resi;
	double ts, te, time_d, time_s, time_ds;
	float* Ts, * xs;
	int* IPIV;
	if ( argc <= 2 ) {
		printf("Usage: %s n(matrix_size) iter(max num of iters)\n", argv[0]);
		exit(1);
	}
	int n = atoi(argv[1]); // Matrix size
	int iter = atoi(argv[2]); // The maximum number of iterations
	int nn = n * n, one = 1, info, i, k;
	A = (double*)malloc(sizeof(double) * n * n);
	T = (double*)malloc(sizeof(double) * n * n);
	Ts = (float*)malloc(sizeof(float) * n * n);
	b = (double*)malloc(sizeof(double) * n);
	x = (double*)malloc(sizeof(double) * n);
	xs = (float*)malloc(sizeof(float) * n);
	IPIV = (int*)malloc(sizeof(int) * n);

	// Genetare a problem (A: random, b: Approximation of A*ones(n,1))
	Gen_Problem(n, A, b, x);
	
	printf("---Performance on double precision---\n");
	dcopy_(&nn, A, &one, T, &one);
	dcopy_(&n, b, &one, x, &one);
	ts = omp_get_wtime();
	dgesv_(&n, &one, T, &n, IPIV, x, &n, &info);
	te = omp_get_wtime();
	time_d = te - ts;
	resi = cheak_resi(n, A, b, x);
	printf("Time: %.2e, Residual: %.2e\n\n", time_d, resi);
	
	printf("---Performance on single precision---\n");
	for (i = 0; i < n * n; i++) { Ts[i] = A[i]; }
	for (i = 0; i < n; i++) { xs[i] = b[i]; }
	ts = omp_get_wtime();
	sgesv_(&n, &one, Ts, &n, IPIV, xs, &n, &info);
	te = omp_get_wtime();
	for (i = 0; i < n * n; i++) { T[i] = Ts[i]; }
	for (i = 0; i < n; i++) { x[i] = xs[i]; }
	time_s = te - ts;
	resi = cheak_resi(n, A, b, x);
	printf("Time: %.2e, Residual: %.2e\n\n", time_s, resi);

	
	printf("---Performance on mixed precision---\n");
	time_ds = time_s;
	for (k = 0; k < iter; k++) {
		ts = omp_get_wtime();
		IterRef(n, A, Ts, b, x, IPIV, one);
		te = omp_get_wtime();
		time_ds += te - ts;
		resi = cheak_resi(n, A, b, x);
		printf("Time: %.2e, Residual: %.2e (iter: %d)\n", time_ds, resi, k + 1);
	}


	
	free(A); free(T); free(b); free(x); free(IPIV);
	free(Ts); free(xs);
	return 0;
}


void IterRef(int n, double* A, float* LU, double* b, double* x, int* IPIV, int iter) {
	double* e, done = 1.0, dmone = -1.0;
	float* xs, * es;
	int i, k, one = 1, info;
	char chrN = 'N';
	xs = (float*)malloc(sizeof(float) * n);
	es = (float*)malloc(sizeof(float) * n);
	e = (double*)malloc(sizeof(double) * n);

	for (k = 0; k < iter; k++) {
		dcopy_(&n, b, &one, e, &one);
		dgemv_(&chrN, &n, &n, &dmone, A, &n, x, &one, &done, e, &one);
		for (i = 0; i < n; i++) { es[i] = e[i]; }
		// Solve e <- A^{-1}(b-Ax)
		sgetrs_(&chrN, &n, &one, LU, &n, IPIV, es, &n, &info);
		// Refine x <- x+e
		for (i = 0; i < n; i++) { x[i] = x[i] + (double)es[i]; }
	}

	free(e);free(xs);free(es);
}

void mydsgesv(int n, double* A, double* b, double* x, int* IPIV, int iter) {
	float* As, * xs;
	int i, one = 1, info;

	As = (float*)malloc(sizeof(float) * n * n);
	xs = (float*)malloc(sizeof(float) * n);
	for (i = 0; i < n * n; i++) { As[i] = A[i]; }
	for (i = 0; i < n; i++) { xs[i] = b[i]; }

	// Solve Ax=b using single precision
	sgesv_(&n, &one, As, &n, IPIV, xs, &n, &info);
	for (i = 0; i < n; i++) { x[i] = xs[i]; }

	// Start iterative refinment
	if (iter > 0) {
		IterRef(n, A, As, b, x, IPIV, iter);
	}
	free(As); free(xs);
}

void Gen_Problem(int n, double* A, double* b, double* w) {
	double done = 1.0, dzero = 0.0;
	char chrN = 'N';
	int i, one = 1;
	for (i = 0; i < n * n; i++) {
		A[i] = rand() / (double)RAND_MAX;
	}
	for (i = 0; i < n; i++) {
		w[i] = 1.0;
	}
	dgemv_(&chrN, &n, &n, &done, A, &n, w, &one, &dzero, b, &one);
}

double cheak_resi(int n, double* A, double* b, double* x) {
	double* v;
	double resi_nrm, x_nrm;
	double done = 1.0, dmone = -1.0;
	int one = 1;
	char chrN = 'N';

	v = (double*)malloc(sizeof(double) * n);
	dcopy_(&n, b, &one, v, &one);
	dgemv_(&chrN, &n, &n, &dmone, A, &n, x, &one, &done, v, &one);
	resi_nrm = dnrm2_(&n, v, &one);
	x_nrm = dnrm2_(&n, x, &one);
	free(v);
	return resi_nrm / x_nrm;
}
