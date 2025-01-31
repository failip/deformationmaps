<script lang="ts">
	import uvunwrapFragmentShader from '$lib/shaders/uvunwrap.frag.glsl?raw';
	import uvunwrapVertexShader from '$lib/shaders/uvunwrap.vert.glsl?raw';
	import differenceFragmentShader from '$lib/shaders/difference.frag.glsl?raw';
	import differenceVertexShader from '$lib/shaders/difference.vert.glsl?raw';
	import applydeformationFragmentShader from '$lib/shaders/applydeformation.frag.glsl?raw';
	import applydeformationVertexShader from '$lib/shaders/applydeformation.vert.glsl?raw';
	import {
		AmbientLight,
		FloatType,
		Mesh,
		PerspectiveCamera,
		PlaneGeometry,
		RGBAFormat,
		Scene,
		ShaderMaterial,
		WebGLRenderer,
		WebGLRenderTarget,
		Texture
	} from 'three';
	import { GLTFLoader } from 'three/examples/jsm/Addons.js';

	let renderer: WebGLRenderer;
	let camera: PerspectiveCamera;
	let loader: GLTFLoader;
	const materials: ShaderMaterial[] = [];
	const scene = new Scene();

	function initializeRendering(canvas: HTMLCanvasElement) {
		renderer = new WebGLRenderer({ canvas, antialias: true });
		renderer.setClearColor(0xffffff);
		renderer.autoClear = false;
		renderer.setPixelRatio(window.devicePixelRatio);
		camera = new PerspectiveCamera(42, 1, 0.1, 1000);
		camera.position.z = 2;
		camera.position.y = 0.9;
		loader = new GLTFLoader();
		renderDifference();
	}

	async function renderDifference() {
		const size = 1024;
		const renderTarget1 = new WebGLRenderTarget(size, size, {
			type: FloatType,
			format: RGBAFormat
		});
		const renderTarget2 = new WebGLRenderTarget(size, size, {
			type: FloatType,
			format: RGBAFormat
		});
		const renderTarget3 = new WebGLRenderTarget(size, size, {
			type: FloatType,
			format: RGBAFormat
		});

		const unwrapMaterial = new ShaderMaterial({
			vertexShader: uvunwrapVertexShader,
			fragmentShader: uvunwrapFragmentShader
		});

		const applyDeformationMaterial = new ShaderMaterial({
			vertexShader: applydeformationVertexShader,
			fragmentShader: applydeformationFragmentShader,
			uniforms: {
				uDisplacementScale: { value: 1.0 },
				tDisplacement: { value: null },
				tDiffuse: { value: null }
			}
		});

		const normal = await loader.loadAsync('models/normaluv.glb');
		const large = await loader.loadAsync('models/largeuv.glb');
		normal.scene.traverse((child) => {
			if (child instanceof Mesh) {
				const clone = child.clone();
				const colorMap = child.material.map.clone() as Texture;
				child.material = unwrapMaterial.clone();
				clone.material = applyDeformationMaterial.clone();
				materials.push(clone.material);
				clone.material.uniforms.tDisplacement.value = renderTarget3.texture;
				clone.material.uniforms.tDiffuse.value = colorMap;
				scene.add(clone);
			}
		});
		large.scene.traverse((child) => {
			if (child instanceof Mesh) {
				child.material = unwrapMaterial;
			}
		});

		renderer.setRenderTarget(renderTarget1);
		renderer.render(normal.scene, camera);
		renderer.setRenderTarget(renderTarget2);
		renderer.render(large.scene, camera);

		const differenceMaterial = new ShaderMaterial({
			vertexShader: differenceVertexShader,
			fragmentShader: differenceFragmentShader,
			uniforms: {
				tDiffuse1: { value: renderTarget1.texture },
				tDiffuse2: { value: renderTarget2.texture }
			}
		});
		const fullScreenQuad = new Mesh(new PlaneGeometry(2, 2), differenceMaterial);
		renderer.setRenderTarget(renderTarget3);
		renderer.render(fullScreenQuad, camera);

		const light = new AmbientLight(0xffffff, 5);
		scene.add(light);
		renderer.setRenderTarget(null);
		renderer.render(scene, camera);
	}
</script>

<canvas id="canvas" use:initializeRendering></canvas>
<input
	type="range"
	name="breastSlider"
	id="breastSlider"
	min="0"
	max="100"
	value="100"
	step="1"
	oninput={() => {
		const slider = document.getElementById('breastSlider') as HTMLInputElement;
		const value = parseInt(slider.value) / 100;
		materials.forEach((material) => {
			material.uniforms.uDisplacementScale.value = value;
		});
		renderer.render(scene, camera);
	}}
/>

<style>
	#canvas {
		width: 512px;
		height: 512px;
		background-color: white;
		border: 1px solid black;
	}
</style>
