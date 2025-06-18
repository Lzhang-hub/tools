# 构建个人开发镜像
build_and_push_image() {
  echo $1 $2 $3 $4 $5
  local ubuntu_version=$1
  local py_version=$2
  local cuda_version=$3
  local torch_version=$4
  local version=$5

  # 下载miniconda
  if [ "$py_version" == "3.10" ]; then
    local conda_version=Miniconda3-py310_23.11.0-1-Linux-x86_64.sh
  elif [ "$py_version" == "3.9" ]; then
    local conda_version=Miniconda3-py39_23.11.0-1-Linux-x86_64.sh
  elif [ "$py_version" == "3.8" ]; then
    local conda_version=Miniconda3-py38_23.11.0-1-Linux-x86_64.sh
  else
    echo "Unsupported python version: $py_version"
    exit 1
  fi       

  mkdir -p tmp
  wget http://nexus.kcs.ke.com/repository/kcs-binary-hosted/aistudio/miniconda/$conda_version -O ./tmp/$conda_version

  # 定义镜像名称
  local t_name="bj-harbor01.ke.com/aistudio-kic/zl-dev/base:ubuntu-$ubuntu_version-torch$torch_version-cuda$cuda_version-$version"
  local base_name="nvcr.io/nvidia/cuda:$cuda_version-devel-ubuntu$ubuntu_version"

  # 构建 Docker 镜像
  export DOCKER_BUILDKIT=1
  echo "Building Docker image with tag: $t_name, ubuntu version: $ubuntu_version, python version: $py_version"
  DOCKER_BUILDKIT=1 docker build --network host -f Dockerfile_dev.base -t "$t_name" --build-arg FROM_BASE="$base_name" --build-arg CONDA_VERSION="$conda_version" .

  # 推送 Docker 镜像到镜像仓库
  echo "Pushing Docker image: $t_name"
  docker push "$t_name"

  # 删除临时文件
  rm -rf tmp
}
ubuntu_version=$1
python_version=$2
cuda_version=$3
torch_version=$4
version=$5


build_and_push_image ${ubuntu_version} ${python_version} ${cuda_version} ${torch_version} ${version}

# case: bash build_base.sh 22.04 3.10 12.5.1 2.6.0 20250319


# test: docker run -it --rm --gpus all -v /data1/nfs15/nfs/bigdata/zhanglei/ml/inference/model-demo/hf/Qwen/Qwen2-7B-Instruct:/mnt/models/model/Qwen2-7B-Instruct -e SELDON_DEPLOYMENT_ID=Qwen2-7B-Instruct harbor.intra.ke.com/aistudio/llm-serving-test/sglang-serving:ubuntu-22.04-torch2.4.0-cuda12.4.1-0.3.3.post1