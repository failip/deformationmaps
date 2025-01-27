<script lang="ts">
	import { PerspectiveCamera, Scene, WebGLRenderer } from 'three';

	let renderer: WebGLRenderer;
	let scene: Scene;
	let camera: PerspectiveCamera;

	function initializeRendering(canvas: HTMLCanvasElement) {
		renderer = new WebGLRenderer({ canvas });
		scene = new Scene();
		camera = new PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);

		renderLoop();
	}

	function renderLoop() {
		requestAnimationFrame(renderLoop);
		renderer.render(scene, camera);
	}
</script>

<canvas id="canvas" use:initializeRendering></canvas>

<style>
	#canvas {
		width: 100%;
		height: 100%;
		background-color: #000;
	}
</style>
